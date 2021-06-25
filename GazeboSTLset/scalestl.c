//scalestl.c
/***************************************************
Copyright 2021 Howard L. Howell

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

********************************************************/
// All my stl files are in mm.  This changes them to meters.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

FILE *Fin, *fi, *Fout;
char foutname[512];
char finame[512];
char *sptr;
char strin[512];
char tempstr[512];
char filestr[512];
char directoryname[512]="";
char label[40];
float x,y,z;
int dir;
char *nameptr;

int main(int argc, char **argv)
{
  if (argc<2){
  	printf("usage:\n");
  	printf(" do an ls -alr > temp.txt in the directory where the stl files are located\n");
  	printf(" then invode this command: scalestl <directory of stl files>/temp.txt\n");
  	printf(" the program will create a directory called \"STL\".\n");
  	printf(" that directory will contain the files converted to mm in the same directory structure as the original.\n");
  	printf(" These converted files are scaled for use with gazebo.  Gopy that STL directory into the appropriate \n");
  	printf(" workspace for your robot in ROS2.\n");
  	printf(" each .stl file can then be imported into gazebo and used to build your robot simulation.\n");
  }
  	
  /* argv [1] should be temp.txt */
  Fin=fopen(argv[1], "r");
  if (!Fin){
    printf (" Couldn't open file: %s\n",argv[1]);
    printf (" This should be temp.txt in your stl directory. for more informaiton try scalestl with no arguments.\n");
    exit(0);
  }
  // now set up the output directory:
  dir=mkdir("./STL",0755);
  if(dir==-1){
  	printf("STL directory exists\n");
  }
  else if(dir==0){
  	printf("Directory Created!\n");
  }
  else{
  	printf ("system error, couldn't create the .STL directory\n");
  }
  while (fgets(filestr,256,Fin)) // read lines from temp.txt
  {
  	if ((strlen(filestr)<2)||(strstr(filestr,"temp.txt")))
  		x=x; // do nothing on empty strings. or the list file
  	else if ((strlen(filestr)<44)){ //a directory or a number.
  		if (!strstr(filestr,"total")){ //if it is not the total.
  			*strstr(filestr,":")='\0'; // remove the colon
  			strcat (filestr,"/");    // add the slash
  			strcpy (directoryname, filestr);
  			strcpy (tempstr,"./STL/"); // now build up the subdirectory in the output.
  			strcat (tempstr,directoryname);
  			dir=mkdir(tempstr,0755); // make the new subdirectory
		 	if(dir==-1){
				printf("STL directory exists\n");
			}
			else if(dir==0){
				printf("Directory Created!\n");
			}
			else{
				printf ("system error, couldn't create the .STL directory\n");
			}
  		}		
  	}
  	else{  // if here we have a file name to work with or the . or .. directories
  		nameptr=strstr(filestr,":")+4; // the al format has the date and time with a ";" between the hours and minutes.  Minutes is 2 characters, and then a space , so 4 characters until the name begins.
  		if (*nameptr!='.'){  // don't parse hidden or directories . or ..
	  		strcpy(tempstr, nameptr); // get just the filename
	  		*strstr(tempstr,"\n")='\0';    // get rid of the "/n".
	  		strcpy (finame, directoryname); // if in a subdirectory, add that.
	  		strcat (finame, tempstr);       // and the filename to read.
	  		fi=fopen(finame,"r");           // now open it.
	  		if (!fi){ // the open failed.
				printf ("opening file: \"%s\" failed. Check that it is in the current directory.\n",finame);
				exit(0);
			}
			strcpy(foutname,"./STL/");           // the STL direcotry is where we will put the output files.
	  		strcat(foutname,directoryname);      // subdirectory
	  		strcat(foutname,tempstr); // get the new output file name.
	  		Fout=fopen(foutname,"w"); // and open it for writing.
			if(!Fout){
			    printf(" Couldn't open the output file: %s\n",foutname);
			    exit(0);
			}
			while (fgets(strin,256,fi))
		 	{
			    if (sptr=strstr(strin,"vertex"))
			    {
			      sscanf(sptr,"%s %g %g %g", label,&x,&y,&z);
			      sprintf( strin,"      vertex %e %e %e\n",x/1000.0,y/1000.0,z/1000.0);
			    }
			    fprintf(Fout,"%s",strin);
			}
			fflush(Fout);
			fclose(Fout);
			fflush(fi);
			fclose(fi);
		}
	}
}
printf("Done!! output is:in the STL directory.\n");
 }   
