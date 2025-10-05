#!bin/bash
#Skapad av Jakob Sertcanli, grupp 9

RED='\033[0;31m'
GREEN='\033[0;32m'
No_Color='\033[0m'
option="MAIN_MENU"
user=""


#Tar fram id:et för användaren som startade den här sessionen
#Bara root får tillgång till programmet
if [[ $(id -u) -eq 0 ]]; then
		

	#Printar ut en banner

	printbanner () {
		
		echo "****************************************"
                echo "                $1                      "
                echo "----------------------------------------"

	}


	#Hela programmet är i en konstant gående loop, man återgår allltid till menyn när man är klar
	#Delad upp i subsater
	
	while true

	do

			clear
						
			case $option in

				MAIN_MENU)



			
					#Huvudmenyn

					echo "****************************************"
					echo  -e "        ${GREEN}    SYSTEM MANAGER      "
					echo "----------------------------------------"
					echo -e  "${RED} ci${No_Color} - Computer Info   (Computer information)" 
					echo  -e " "
					echo  -e "${RED} ua${No_Color} - user add        (Create a new user)"
					echo  -e "${RED} u1${No_Color} - user List       (List all login users"
					echo  -e "${RED} uv${No_Color} - user view       (View user properties"
					echo  -e "${RED} um${No_Color} - user modify     (Modify user properties"
					echo  -e "${RED} ud${No_Color} - user delete     (Delete a login user)"
					echo  -e " "	
					echo  -e "${RED} ga${No_Color} - Group Add       (Create a new Group)"
					echo  -e "${RED} g1${No_Color} - Group List      (List all groups, not system groups)"
					echo  -e "${RED} gv${No_Color} - group view      (List all users in group)"
					echo  -e "${RED} gm${No_Color} - Group modify    (Add/remove user to/from a group)"
					echo  -e "${RED} gd${No_Color} - Group Delete    (Delete a group, not a system group)"
					echo  -e " "

					echo  -e "${RED} fa${No_Color} - Folder Add      (Create a new folder)"
					echo  -e "${RED} fl${No_Color} - folder list     (view content ina folder)"
					echo  -e "${RED} fv${No_Color} - Folder View     (View folder properties)"
					echo  -e "${RED} fm${No_Color} - Folder modify   (Modify folder properties)"
					echo  -e "${RED} fd${No_Color} . Folder Delete   (Delete a folder)"
					echo  -e " " 
					echo  -e "-----------------------------------------"

					echo -n "Choice: "
					read option
					
					;;	
		


			#Visar information om operativsystemet, nätverket och annan hårdvara
			#Kommandon som används är cut, sed och translate för att bearbeta informationen som hämtas från andra kommandon.
				ci)

					clear
				
					echo "*********************************************"
                        		echo  -e     "               ${GREEN}SYSTEM MANAGER             "
                        		echo "            Computer information          "
					echo "---------------------------------------------"
				
					echo "Computer name:   $(hostnamectl | grep "Static hostname" | cut -d ":" -f2 | sed 's/ //')"
					echo "OS Description:  $(hostnamectl | grep "Operating System" | cut -d ":" -f2 | sed 's/ //')"
					echo "Linux Kernel:    $(hostnamectl | grep "Kernel" | sed "s/ *//" | cut -d ":" -f2 | sed "s/ //")"
					echo "CPU:             $(lscpu | grep "Model name" | tr -s " *" " " | cut -d ":" -f2 | sed 's/ //')"                    
					echo "Total memory:    $(free --giga | grep  "Mem" | cut -d ":"  -f2 | sed 's/ *//' | cut -d " " -f1)GB"
					echo "Free disk space: $(df -h --total | grep total | grep -o '[0-9]*%')"
					echo "IP-address:      $(ip addr | grep "scope global dynamic noprefixroute" | sed 's/ *inet *//' | cut -d " " -f1)"
					echo "----------------------------------------"


					echo -n "Press enter to continue..."
					read option

					if [[ $option == "" ]]; then
						option="MAIN_MENU"
						clear						
					fi

					
					;;
			

				ua)
				
				
					#Låter användaren lägga till användare
					#Frågar först efter användarnamnet.
					#Slutligen används passwd för att lägga till ett lösenord också
					#En loop som hela tiden promptar användaren om användaren är upptagen eller annat problem.

				

                             

					while true
					do 
						clear
						printbanner "add user"
						echo -n  "Please enter the username for the new user (can not contain any special symbols), press enter to exit: "
						read username
				
					
						if [[ -z $username ]]; then
							option="MAIN_MENU"
							clear
							break
						fi 

						if  [[ "$username" != *[-,!@()/\^$£#]* ]]; then
							clear
						
							printbanner "add user"
							appearances=$( cat /etc/passwd | grep --no-ignore-case -we "^$username" | wc -l) 
				
							if [[ $appearances -eq 0 ]]; then  
								
								echo -n "Should this user have a home directory? (yes/no)"
								read homedirectory
								echo -n "Enter a comment for this user: "
								read comment

								if [[ $homedirectory == "yes" ]]; then
									useradd -m -c "$comment" -s /bin/bash $username 2> /dev/null
								else 	
									useradd -M -c "$comment" -s /bin/bash $username 2> /dev/null
								fi	
								
								
		                                        	passwd $username
								
								if [[ $? -eq 0 ]]; then
        		                    		        	echo "User, $username created"
								else 
									echo "Something went wrong!"
								fi


							else 
								echo "This user already exists"
								echo "Press enter to go back: "

								read
								continue 
							fi			
						else 
							echo "A username can not be empty or contain special characters"
							echo "Press enter to go back: "
							read 
							continue
							clear
						fi
									
						

   	                            		echo -n "Press enter to go back..."
        	                       		read option
					
						
						
						
						clear
						
                  
						
		
					done
					
					;;

				ul)

					clear
				
					#Listar användare
					#Hämtar först informationen i etc/passwd och sedan förfinar det med hjälp aav column
					
					printbanner "user list"                                       

                                        useridlist=$(cat /etc/passwd | cut -d ":" -f3)
					

                                        echo "" > /root/nonsystemusers.txt

                                        for id in $useridlist; do
						
					#x:$id ser till att vi endast hämtar uid, inte grupp id"	
                                                if [[ "$id" -ge 1000 ]] ; then
                                                        cat /etc/passwd | grep -w "x:$id" | cut -d ":" -f1 >> /root/nonsystemusers.txt
                                                fi
                                        done

                                        cat /root/nonsystemusers.txt | column -x -c 60
                                        echo "" > /root/nonsystemusers.txt

			
					echo -n "Press enter to continue..."
                                	read 

                                
                                        option="MAIN_MENU"
                                        clear

					;;


				uv)
				
					clear
				
					#Hämtar information från en speicifk användare
					#Bearbetar userInfo beroende på vilken information som ska visas	
					#I efterhand visas information om vilka grupper användaren tillhör
					printbanner "user information"

					echo -n "Please enter the user you want to search up (enter to exit): "
				
					read user
				


				
					if [[ -z $user ]]; then
						option="MAIN_MENU"
						continue
					fi
			 

					if [[ $(cat /etc/passwd | grep --no-ignore-case -w "^$user" | wc -l) -eq 0 ]]; then
						echo "This user does not exist"
						echo -n "Press enter to go back: "
						read				
						continue		
				
					else 
						userInfo=$(cat /etc/passwd | grep -w  "$user")
					
					
						echo "User:      $(echo $userInfo | cut -d ":" -f1)"
						echo "Password:  $(echo $userInfo | cut -d ":" -f2)"
						echo "User ID:   $(echo $userInfo | cut -d ":" -f3)"
						echo "Group ID:  $(echo $userInfo | cut -d ":" -f4)"
						echo "Comment:   $(echo $userInfo | cut -d ":" -f5)"
						echo "Directory: $(echo $userInfo | cut -d ":" -f6)"
						echo "Shell:     $(echo $userInfo | cut -d ":" -f7)"
						
											
					
						#Visar användarens grupp id, även när den är dödad
						echo "Groups:   $(groups $user 2> /dev/null | cut -d ":" -f2)"
					fi
				
					echo -n "Press enter to exit..."

					read option
			

					
                        	        option="MAIN_MENU"
					user=""
                                        clear

					
					;;

		
			
				um) 

					clear				
				
					#Modiferar användare som redan existerar med hjälp av usermod
					#Först visas en huvudmeny med 7 olika alternativ.
					#Därefter skriver användaren in användaren som ska modifieras
				
					printbanner "modify user"

				
		


                        	        echo " 1) Username"
                                	echo " 2) Password"
                                	echo " 3) User ID"
                                	echo " 4) Group ID"
                                	echo " 5) Comment"
                                	echo " 6) Directory"
					echo " 7) Shell"
					echo " 8) Quit"

					echo -n "The username you want to edit (enter to exit): "
                                	read username

					if [[ -z $username ]]; then
						clear
						option="MAIN_MENU"
						continue
					fi

				
					if [[ $(cat /etc/passwd | grep -w "^$username" | wc -l) -eq 0 ]]; then

                        	                echo "The user $username does not exist"                         
                                	        echo -n "Press enter to go back: "
						read
						continue				
                                        	clear

                                	else
						echo -n "Make a choice please: "
                                		read selection
				
						clear
					
						printbanner "modify user"

                                		case $selection in
                                        		1)
								echo -n "The new name for this user: "
								read newusername
										
								if [[ "$newusername" == *[-,!@()/\^$£#]* ]]; then
	
									echo "No special characters allowed"
									echo -n "Press enter to go back: "
									read 
									clear
									continue
								fi
						   
								if [[ $(cat /etc/passwd | grep --no-ignore-case -we "^$newusername" | wc -l) -eq 1 ]]; then
									
                	                        			echo "The user $newusername already exists"                         
                        	               				echo -n "Press enter to go back: "
								
                                        				read
                                        				clear
									continue
		
                	                			fi

						
								#Ändrar namnet för användaren
								#Uppdatera gruppnamnet
								#Skapar ett ny mapp för användaren med det uppdaterade namnet
								#Flytta över allt till den nya mappen.

								
								usermod -l $newusername $username
								groupmod -n $newusername $username
								usermod -d /home/$newusername -m $newusername
						

                                        	        	echo "the user $username is now named $newusername"
							
								echo "Press enter  to continue"
								read 
						
                                        	        	;;

                                       		 	2) 
								echo -n "Enter the new password for this user: "
								read password
						

								usermod -p $password $username
                                                
								if [[ $? -eq 0 ]]; then
									echo "Updated the password for the user $username"
								fi

								echo "Press enter to continue.. "
								read	
								;;                            

                                        		3) 
								echo "Enter the new userid"
                                                		read userid
							
							
								usermod -u $userid $username 
									
								if [[ $? -eq 0 ]]; then
									echo "Updated the userid for the user $username"
								fi

								echo "Press enter to continue.."
								read
	
								;;

                	                        	4) 
								echo "Enter the name of the group you want to add this user to: "
							
								read groupname
								usermod -g $groupname $username
        	                                	
								if [[ $? -eq 0 ]]; then
									echo "group id updated to $groupname"
								fi

								echo "Press enter to continue .."
                        	                        	read 
							
								;;

                                	        	5) 
						
								echo -n "Enter the new comment for this user: "
		
	                                                	read comment
								usermod -c "$comment" $username
								
								if [[ $? -eq 0 ]]; then
									echo "Updated the comment for the user $username"
								fi
							
						
								echo "Press enter to continue... "
								read
								;;

                                        		6)

								echo -n "Enter the new home directory: "
								read directory
							
							
								usermod -d $directory -m $username
	
								if [[ $? -eq 0 ]]; then
									echo "Directory updated to $directory"
								fi
	
        	                                        	echo "Press enter to continue..."
								read 
								;;


							7)
								echo "Enter the path to the shell: "
								read shell
								chsh -s shell $username 

								if [[ $? -eq 0 ]]; then
									echo "Updated the shell for the user $username"
								fi

								echo "Press enter to continue..."
								read
							
						
								;;

							8) 	
								clear
								option="MAIN_MENU"	
								
                                				;;
						esac
					fi

					clear
					;;
			
					
				ud)
					clear		
				
					#Tar bort användare
					printbanner "delete user"

					echo -n "The user you want to delete (Enter to exit): "
					read username	
				
								
					if [ -z $username &> /dev/null ]; then
					
						clear
						option="MAIN_MENU"
					
                        		elif [[ $(cat /etc/passwd | grep --no-ignore-case -we "^$username" | wc -l) -eq 0 ]]; then

                                		echo "The user $username does not exist"
                                        	echo -n "Press enter to continue: "
                                        	read
                         			clear
                                	else

						userdel -r $username 2> /dev/null 
						if  [[ $? -eq 0 ]]; then
							echo "The user $username got deleted"
						else 
							echo "Something went wrong, dont use any special characters"
						fi	
					
					 
						echo -n "Press enter to exit: "
						read
						clear
						option="MAIN_MENU"
			
					fi
					
					;;	

				ga)
					
					clear

					#Skapar nya grupper
					#Grupper kan inte ha special karaktärer, används för att undvika fel.

					printbanner "add group"

					echo -n "Please enter the name for the group you want to create "
					echo -n "(Press enter to exit): "

					read groupname
				
					if [[ "$groupname" == *[-,!@()/\^$£#]* ]]; then

						echo "No special characters allowed"
						echo -n "Press enter to continue"
						read
						clear	

					elif [[ -z $groupname ]]; then
						option="MAIN_MENU"
						clear

				
					elif [[ $(cat /etc/group | grep -w "^$groupname" | wc -l) -eq 1 ]]; then 
						echo "This group already exists"
						echo -n "Press enter to continue"
						read 
						clear
					else 
						groupadd $groupname
						echo "$groupname group created"
						echo -n "Press enter to exit: "
						read
						clear
						option="MAIN_MENU"
					fi

					;;

				gl)
					
					clear	

					#Listar alla grupper som har större är lika med 1000 i id (Alla användargrupper)
					printbanner "group list"

					groupidlist=$(cat /etc/group | cut -d ":" -f3)				
				

					echo "" > /root/nonsystemusers.txt 

					for id in $groupidlist; do 
					
						if [[ "$id" -ge 1000 ]]; then
							cat /etc/group | grep -w $id | cut -d ":" -f1 >> /root/nonsystemusers.txt
						fi
					done

					cat /root/nonsystemusers.txt | column -x -c 60
					echo "" > /root/nonsystemusers.txt
				
					echo -n "Press enter to exit: "
					read 
				
					option="MAIN_MENU"
					clear

					;;
		
				

				gv)
					
					clear

					#Kollar upp grupp information
					#Gruppen måste existera
			

					printbanner "group view"
					echo -n "Please, enter the group you want to list all users for (Press enter to exit): "
					read groupname

					if [[ -z $groupname ]]; then
						clear
						option="MAIN_MENU"
						continue
					fi
					
					if [[ $(cat /etc/group | grep -w "^$groupname" | wc -l) -eq 1 ]]; then
					
						#Om det är en primär grupp så skrivs också användaren ner	
						if [[ $(cat /etc/passwd | grep -w "^$groupname" | wc -l) -eq 1 ]]; then	
							echo "All users in this group: $groupname,$(cat /etc/group | grep -w "^$groupname" | cut -d ":" -f4)"
						else 
							echo "All users in this group: $(cat /etc/group | grep -w "^$groupname" | cut -d ":" -f4)"
						fi
				
					else 
						echo "The group $groupname does not exit"
						echo -n "Press enter to continue: "
						read
						continue
					fi
				
					echo -n "Press enter to exit: "
					read	
					option="MAIN_MENU"

					;;

				gm)
					
					clear

					#Modifierar grupper som redan finns
					#Först presenteras en meny för användaren
					#Därefter har användaren två val, man kan antagligen lägga till användare i en grupp eller ta bort en användare från en grupp
					printbanner "modify group"

					echo " 1) Add user to a group."
					echo " 2) Remove user from a group."
					echo " 3) Exit to menu"
					echo -n "Choice: "
					
					read selection	
					echo -n "Option: "			
					case $selection in
					
						1) 	
							clear
							echo -n "Enter the groupname: "
							read groupname

							if [[ $(cat /etc/group | grep -w "^$groupname" | wc -l) -eq 1 ]]; then
							
								echo -n "Enter the user: "
								read username 

								if [[ $(cat /etc/passwd | grep -w "^$username" | wc -l) -eq 1 ]]; then
									usermod -a -G $groupname $username					
									
									if [[ $? -eq 0 ]]; then			
										echo "User $username added to group"
									else 
										echo "Something went wrong"
									fi

									echo "Press enter to go back to the previous menu: "
									read
									clear
								else 
									echo "The user $username does not exist: "
							        	echo "Press enter to go back to the previous menu: "
                                                        		read
                                                       		 	clear   
								fi
							else 
								echo "The group $groupname does not exist "
								echo "Press enter to go back to the previous menu: "
								read
								clear	
							fi
				
							;;

						2) 
							clear
							echo -n "Enter the groupname: "
                                        	        read groupname

                                        	        if [[ $(cat /etc/group | grep -w "^$groupname" | wc -l) -eq 1 ]]; then

                                                	        echo -n "Enter the user: "
                                                        	read username

                                                        	if [[ $(cat /etc/passwd | grep -w "^$username" | wc -l) -eq 1 ]]; then
								
									if [[ $(cat /etc/group | grep -w "^$groupname" | grep "$username" | wc -l) -eq 1 ]]; then
										gpasswd -d $username $groupname &> /dev/null								
                                                                	
										if [[ $? -gt 0 ]]; then
											echo "Something went wrong, perhaps you are trying to delete a primary group user"
										else

											echo "User $username removed from  group"
										fi

										echo "Press enter to go back to the previous menu: "
										read 
										clear
									else 
										echo "User $username is not a part of the group, $groupname"
										echo -n "Press enter to continue: "
										read
										clear
									fi
                                                        	else
                                                                	echo "The user $username does not exist: "
                                                                	echo "Press enter to go back to the previous menu: "
                                                                	read
                                                                	clear
                                                        	fi
                                                	else
                                                	        echo "The group $groupname does not exist "
                                                	        echo "Press enter to go back to the previous menu: "
                                                	        read
                                                	        clear
                                               		fi          
                                                               
                                                                                                            
                           				;;
	
						3) 
							clear
						   	option="MAIN_MENU"
						
							;;

					esac
					;;	

				gd)
					
					clear
				
					#Tar bort användare skapad av användare, inte systemgrupper
					#Frågar först efter användarnamnet och tar sedan fram id:et för användaren för att se till att man inte tar bort systemgrupper
					#Till slut visas resultatet.
					printbanner "delete group"

					echo -n "Please, enter the group you want to delete (press enter to exit): "
					read groupname

					if [[ -z $groupname ]]; then
						option="MAIN_MENU"
						clear
						continue
					fi

					if [[ $(cat /etc/group | grep -w "^$groupname" | wc -l) -eq 1 ]]; then

						if [[ $(cat /etc/group | grep -w "^$groupname" | cut -d ":" -f3) -lt 1000 ]]; then
							echo "The group that you are trying to delete is a system group"
							echo -n "Press enter to go back: "
							read
							continue
						

						else
							groupdel $groupname
						
							if [[ $? -eq 0 ]]; then
								echo "$groupname deleted"
							fi								                                               
						
							echo -n "Press enter to exit: "
							option="MAIN_MENU"
							read
	
						fi

					else 
						echo "This group does not exist"
						echo -n "Press enter to start over: "
						read
						continue
						clear
					fi

					break
					
					;;	
				
				fa)
					
					#Lägger till nya mappar
					#Går inte skapa nya mappar i sökväggar som redan har en mapp med samma namn.
					clear

					printbanner "add folder"

					echo -n "The name of the new folder (enter to exit): "
					read foldername	
				



					if [[ -z $foldername ]]; then
						option="MAIN_MENU"
						clear
						continue
					fi

					echo -n "Where should the file be? (enter to exit): "
					read location

					if [[ -z $location ]]; then
						option="MAIN_MENU"
						clear
						continue
				
					fi

					if [[ $(ls $location | grep -w $foldername | wc -l) -eq 1 ]]; then
					
						echo "This folder already exists in this directory"
						echo "Press enter to start over"
						read 
						clear
						continue
					else
						mkdir $location/$foldername &> /dev/null
					
						if [[ $? -eq 0 ]]; then
							echo "$foldername created in $location"
						else
							echo "This path does not exist"
							echo -n "Press enter to start over"
							read
							continue

						fi

						echo "Press enter to go back"
						read
						clear						
					fi


					;;

				fl)
				
					clear
				
					#Listar ut information om en mapps innehåll
					#Delas upp i filer och i submappar
					# $? används för att kolla om sökvägen faktiskt finns.
					printbanner "folder list"

					echo -n "Please enter the location for the directory you want to view (press enter to exit): " 		
				
					read folderlocation
				

					if [[ -z $folderlocation ]]; then
						clear
						option="MAIN_MENU"
						continue
					fi
				

					ls $folderlocation &> /dev/null
				
			
					if [[ $? -eq 0 ]]; then
					
						echo " "
						echo "Folders in $folderlocation:"
						ls -l $folderlocation | grep "^d" | tr -s " *" " " | cut -d " " -f9 | column
				
						echo " "
						echo " "

						echo "Links in $folderlocation:"
                                        	ls -l $folderlocation | grep "^l" | tr -s " *" " " | cut -d " " -f9 | column

						echo " "
						echo " "

						echo "Files in $folderlocation:"
						ls -l $folderlocation | grep "^-" | tr -s " *" " "| cut -d " " -f9 | column 
						echo " "
						echo " "
				
						echo -n "Press enter to exit:"
						read
						clear
						option="MAIN_MENU"
					else 
						echo "The path $folderlocation does not exist"
						echo -n "Press enter to go back:"
						read
						clear
						continue
			
					fi
				
					;;


				fv)
					
					clear

					printbanner "folder view"
					#Listar en mapps rättigheter
					#Loopar igenom den första delen av ls som visas alla rättigheter.
					#userright är en ackumulator som används för att underlätta för personer som inte använder linux.
					#Modulo operatorn används för korta ner koden, det finns ju bara tre primärfall.
				
					#Visar all information om en mapp som visas med ls kommandom med -l flaggan.
					#Lastly modified visas i slutet.
					echo -n "Please, enter the absolute path to the directory (press enter to exit): "
					read filepath

					if [[ -z $filepath ]]; then
						clear
						option="MAIN_MENU"
						continue
					fi
				
					#Kollar om mappen faktiskt finns med hjälp av -directory test.
			
					if [[ -d $filepath ]]; then		

						rights=$(ls -ld $filepath |  cut -d " " -f1  | sed "s/./& /g")
						#. Matchar alla singel karaktärer, & är den matchade karaktären och mellanrummet efteråt representerar
						#Mellanrumet som vi lägger till. Det här görs för alla karaktärer (globalt)
										
						counter=0
						userrights=""
						currentgroup=0
					
						echo " "
						echo " "	
						echo "Folder Owner: $(ls -dl $filepath | cut -d " " -f3)"
						echo "Group Owner:  $(ls -dl $filepath | cut -d " " -f4)"
						echo " "
						echo " "
						for right in $rights; do

							if [[ $right == "r" ]]; then
								userrights+=$'Read is on\n'
					
							elif [[ $counter -eq 1 ]]; then
								userrights+=$'Read is off\n'
							fi

							if [[ $right == "x" ]] || [[ $right == "s" ]] || [[ $right == "t" ]]; then
								userrights+=$'Execute is on\n'
						
							elif [[ $counter -eq 3 ]]; then
								userrights+=$'Execute is off\n'
	
							fi
		
							if [[ $right == "w" ]]; then
								userrights+=$'Writing is on\n'
						
							elif [[ $counter -eq 2 ]]; then
								userrights+=$'Writing is off \n'
							fi

							if [[ $right == "s" ]] || [[ $right == "S" ]]  && [[ $currentgroup -eq 0 ]]; then
						
								userrights+=$'Setuid is on\n'
					
							elif [[ $right == "s" ]] || [[ $right == "S" ]] && [[ $currentgroup -eq 1 ]]; then
								userrights+=$'Setgid is on\n'

							elif [[ $right == "t" ]] || [[ $right == "T" ]]; then
								userrights+=$'Sticky bit is on\n'
							fi
		
						

							if [[ $counter -eq 3 && $currentgroup -eq 0 ]]; then
                                                
								echo "Directory creator's permissions: "
								echo -e "$userrights"
								((currentgroup++))
								userrights=""
								echo " "

                                       			 elif [[ $counter -eq 3 && $currentgroup -eq 1 ]]; then
                                                
								echo "Group owner's permissions: "
								echo -e "$userrights"
								((currentgroup++))
								userrights=""
								echo " "

                                        		elif [[ $counter -eq 3 && $currentgroup -eq 2 ]]; then
                                                		echo "Everyone else's permissions:   "
								echo -e "$userrights"
								userrights=""
								echo " "
                                        		fi

							counter=$((counter % 3))
							((counter++))
						done
				
							echo "Lastly modified: $(ls -ld $filepath | tr -s " *" " " | cut -d " " -f6) $(ls -ld $filepath | tr -s " *" " " | cut -d " " -f7) $(ls -ld $filepath | tr -s " *" " " | cut -d " " -f8)"

					else
						echo "The given path does not exist"
						echo -n "Please press enter to go back"
						read
						clear
						continue
					fi
						
					echo -n "Press enter to go back: "
					read
					clear
				
					;;

				fm)


				
					#Låter användare modifiera en mapps rättigheter



					clear

					printbanner "modify folder"
					menuloop=1
				
					#Visar upp de olika alternativ man har när man väl har valt en rättighet man vill ändra.
					#Man kan lägga till eller ta bort en rättighet.
					#touch används för uppdatera senaste modifikations datumet.

					changepermission () {
						 clear
					 
						 echo " 1) Add $1"
                                        	 echo " 2) Remove $1"
						 echo " *) Anything else to go back"					
						 echo -n "Option: "
                                        	 read optionalternative

                                        	 case $optionalternative in

                                         		1)
								clear
                                                		chmod $2+$3 $5
                                                        	echo "$1 permission now on for the $4 users"
								touch $5
								echo "Press enter to go back"
								read
								clear
							
                                                		;;


                                                	2)
								clear
                                                		chmod $2-$3 $5
                                                        	echo "$1 permission now off for the $4 users"
								touch $5
								echo "Press enter to go back to the menu"
								read
								clear
							
                                                		;;

                                                	*)
								clear
                                                      

                                                		;;
                                          	esac

					
					
					}

					#Visar alla alternativ man har
					#Finns tre olika fall, primäranvändaren, primärgruppen och andra användare.
					#Alla fall har sina egna permissions.
				
					permissionalternatives (){
					
						clear
						printbanner "folder perms"

						echo " 1) write"
						echo " 2) read"
						echo " 3) execute"
					
						if [[ $1 -eq 1 ]]; then
							echo " 4) setuid"
						elif [[ $1 -eq 2 ]]; then
							echo " 4) setgid"
						elif [[ $1 -eq 3 ]]; then
							echo " 4) stickybit"
						fi
	
						echo " 5) go back"
				
					}

					#Val till undermenyn
					#permissionalternatives visar dem alternativ man har 
				

					undermenu () {
					
					
						while true

						do


							clear
					
					


							case $1 in 
								1) 
									permissionalternatives "$1"
									echo -n "Option: "				
									read alternative
							
									#Alla möjliga kombinationer som en användare kan göra för varje grupp
									case $alternative in

										1) 
											changepermission "Write" "u" "w" "User" "$2" 
											;;			
								
										2)
											changepermission "Read" "u" "r" "User" "$2"

											;;

										3)
											changepermission "Exectutable" "u" "x" "User" "$2"

											;;

										4)
											changepermission "Setuid" "u" "s" "User" "$2"
											;;

										5)
											clear
											break
									
							
											;;

									esac

									;;

								2) 
									echo "Group permissions"
									permissionalternatives "$1"
									echo -n "Option: "
                                                        		read alternative

                                                        		case $alternative in

                                                                		1)
                                                                        		changepermission "Write" "g" "w" "Group" "$2"
                                                                			;;

                                                                		2)
                                                                        		changepermission "Read" "g" "r" "Group" "$2"

                                                                			;;

                                                                		3)
                                                                        		changepermission "Exectutable" "g" "x" "Group" "$2"
											;;

										4)

											changepermission "Setgid" "g" "s" "Group" "$2"
											;;

										5)  
											clear
											break
									
									 
											;;
                                                		        esac

									;;

								3) 
									echo "Other's permisions"
									permissionalternatives "$1"
							
									echo -n "Option: "
                                                        		read alternative
							
                                                        		case $alternative in
	
        	                                                        	1)
                	                                                        	changepermission "Write" "o" "w" "Others" "$2"
                        	                                        		;;
	
        	                                                        	2)
        	                                                                	changepermission "Read" "o" "r" "Others" "$2"
	
                	                                                		;;
	
        	                                                        	3)
                        	                                                	changepermission "Exectutable" "o" "x" "Others" "$2"
											;;

										4) 
											changepermission "Sticky bit" "o" "t" "Others" "$2"
											;;

										5) 
											clear
											break
								
											;;

                                                        		esac
							
									;;

								*)	
									clear
									break

									;;
							esac
						done

	
					}

				
					echo -n "Enter the pathway to the directory you want to edit the permisisons for, (press enter to exit): "
					read folderpath
				
			
				
				
					while true 


					do
						clear	
						printbanner "folder perms"

						#Visar de olika val man har 
						#Finns totalt 7 olika alternativ
				
						if [[ -z $folderpath ]]; then
							option="MAIN_MENU"
							break
							clear		
				§
						elif [[ -d "$folderpath" ]]; then

	
							echo " 1) user permissions"
							echo " 2) group's permissions"
							echo " 3) other's permissions"
							echo " 4) folder owner"
							echo " 5) folder group owner"
							echo " 6) exit"
						
							echo -n "Option: "
							read selection
							
							if [[ $selection -eq 6 ]]; then
								option="MAIN_MENU"
								break
								clear
							fi

							if [[ $selection -eq 4 ]]; then
								clear	
								#Chown används för att ändra självaste user användaren till mappen
								printbanner "folder perms"

								echo -n "The user to replace the current owner of the file, (press enter to exit): "
								read user
						
								if [[ -z $user ]]; then
									clear
								else
									chown $user $folderpath
									if [[ $? -eq 0 ]]; then
										echo "Folder owner updated"
									else 
										echo "Obs something went wrong, user may not exist"
									fi

									echo -n "Press enter to go back"
									read
						        		continue	
									clear
								fi

							elif [[ $selection -eq 5 ]]; then
								clear
								#chgrp används för att ändra gruppägare

								printbanner "folder perms"

								echo -n "The group to replace the current group owner of the file, (press enter to exit): "
								read group
	
								if [[ -z $group ]]; then
									clear
				
								else
									chgrp $group $folderpath

									if [[ $? -eq 0 ]]; then
										echo "Folder group owner updated"
									else

										echo "Obs something went wrong, group may not exist"
										
									fi

									echo -n "Press enter to go back"
									read
									clear
								fi
							else

								undermenu "$selection" "$folderpath"
								clear
							fi


						else 
							echo "The path you entered does not exist"
							echo -n "Press enter to start over"
							read
							clear
							break
						fi	

					done
						
					;;		

				fd)
				
					clear
					#Tar bort mappar som redan finns
					#Rm används för att ta bort mapparna rekursivt, mappar med innehåll.
					printbanner "delete folder"

					echo -n "Enter the path to the directory you want to delete (enter to exit): "
					read folderpath
				
					if [[ -z $folderpath ]]; then
						clear
						option="MAIN_MENU"
						continue	
					fi
					
					if [[ -d $folderpath ]]; then

						echo "Are you sure that you want to delete this folder? (Y/N)"
						read confirm

						if [[ $confirm == "Y" ]]; then
							rm -R $folderpath
							echo "$folderpath deleted"
							echo -n "Press enter to exit: "
							read
						else 
							echo "Press enter to exit"
							read
							option="MAIN_MENU"
						fi

					else 
						echo "This folder does not exist"
						echo -n "Press enter to start over"
						read
						continue

					fi

					
					;;

				*)
					option="MAIN_MENU"
					clear	
				
					;;
		esac				
	done


	clear

else 
	echo "You do not have the permission to execute this program"

	
fi

 







