.model small
.stack 100h
.386
.data
    ;file on which to work and handle t store the address of the file...........
    fname         db 'med.txt', 0
    handle        dw ?
    

    ;Menu's main options......................


    welcome       db 10,13,'|>~~~~~~~~~~~~~~~~~~~~~~ASSEMBLY LANGUAGE 8086~~~~~~~~~~~~~~~~~~~~~~~~<|'
                  db 10,13,'|            PUNJAB UNIVERSITY OF COMPUTING AMD INFORMATION TECHNOLOGY |'
                  db 10,13,'|            COURSE:                                                   |'
                  db 10,13,'|                    COMPUTER ORGANIZATION AND ASSEMBLY LANGUAGE       |'
                  db 10,13,'|            INSTRUCTOR:                                               |'
                  db 10,13,'|                             MUHAMMAD ABDULLAH                        |'
                  db 10,13,'|                                   CSF22                              |'
                  db 10,13,'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
                  db 10,13,10,13,'Press Enter to move forward>>>>>>$'



    heading       db 10,13,10,13,'                |**********PHARMACY MANAGEMENT SYSTEM***********|'
                  db 10,13,'                |0. Exit                                        |'
                  db 10,13,'                |1. Add New Medicine                            |'
                  db 10,13,'                |2. View Medicine Details                       |'
                  db 10,13,'                |3. Update Medicine                             |'
                  db 10,13,'                |4. Delete Medicine                             |'
                  db 10,13,'                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$'
                  

    ;input prompt and store the choice in variable................
    inputmsg      db 10,13,10,13,'Choose an option >> $'
      
    ;DATA details.............
    strID         db 10,13, 'Enter Medicine ID:(XXXX) $'
    strName       db 'Enter Medicine Name: $'
    strPrice      db 'Enter Medicine Price: $'


    ;for insert the data in the we will use these array to temprary store the data............
    medicineName  db 28 dup(' '),13,'$'
    medicineID    db 28 dup(' '),13,'$'
    medicinePrice db 28 dup(' '),13,'$'


    ;number of records............................
    nameU1        db 28 dup(' '),13,'$'
    idU1          db 28 dup(' '),13,'$'
    priceU1       db 28 dup(' '),13,'$'
    nameU2        db 28 dup(' '),13,'$'
    idU2          db 28 dup(' '),13,'$'
    priceU2       db 28 dup(' '),13,'$'
    nameU3        db 28 dup(' '),13,'$'
    idU3          db 28 dup(' '),13,'$'
    priceU3       db 28 dup(' '),13,'$'
    nameU4        db 28 dup(' '),13,'$'
    idU4          db 28 dup(' '),13,'$'
    priceU4       db 28 dup(' '),13,'$'
    nameU5        db 28 dup(' '),13,'$'
    idU5          db 28 dup(' '),13,'$'
    priceU5       db 28 dup(' '),13,'$'


    idC           dw 0
    nameC         dw 0
    priceC        dw 0


    ;input the ID
    promptID      db 'Enter Medicine ID:(XXXX) $'
    checkID       db 28 dup(' '),13,'$'
    notFound      db 'Record not found$'

    ;Display two word message according to the choice...................
    exitmsg       db 10,13,10,13, '               ~~~~~~~~~~~~~PHARMACY CLOSED~~~~~~~~~~~~~~~ $'
    addmsg        db 10,13, '               **ADD NEW MEDICINE** $'
    detailmsg     db 10,13, '               **MEDICINE DETAILS** $'
    deletemsg     db 10,13, '               **DELETE MEDICINE**  $'
    updatemsg     db 10,13, '               **UPDATE MEDICINE**  $'



    ;Following 3 line to display work has done successfully.......................
    delete_done   db 10,13, 'Medicine Deleted Successfully $'
    update_done   db 10,13, 'Medicine Updated Successfully $'
    add_done      db 10,13, 'Medicine Added Successfully $'
    invalidoption db 10,13, 'Invalid option!$'



.code
main proc
                     mov  ax,@data
                     mov  ds,ax

    ;displaying menue
    more:            lea  dx,welcome
                     mov  ah,09
                     int  21h

                     mov  ah,01
                     int  21h
                     cmp  al,13
                     jne  more

    Invalid:         lea  dx,heading
                     call string_output
    ;Following 3 lines display the input prompt..................

                     lea  dx,inputmsg
                     mov  ah,09
                     int  21h

                     mov  ah,01h               ; Taking user input..........
                     int  21h
                     sub  al,30h


                     cmp  al,0                 ;if choice  is 0, Exit the pharmacy.......
                     je   ext

                     cmp  al,1                 ;if choice  is 1, Add new medicine to the pharmacy.......
                     je   write_data

                     cmp  al,2
                     je   read_data            ;if choice  is 2, Show the appropriate medicine details against the med ID.......
                        
                     cmp  al,3
                     je   update_data          ;if choice  is 3, Update the medicine details against the med ID..........

                     cmp  al,4
                     je   delete_data          ;if choice  is 4, Delete the medicine details against the med ID...........
                     
                     lea  dx,invalidoption
                     mov  ah,09
                     int  21h
                     jmp  Invalid

                     


    write_data:      
                     lea  dx,addmsg
                     mov  ah,09
                     int  21h

                     call writing_in_file

                     lea  dx,add_done
                     mov  ah,09
                     int  21h
                     jmp  ext


    read_data:       
                        
                        
                     lea  dx, detailmsg
                     mov  ah,09
                     int  21h
                     call new_line
                        
                     lea  dx,promptID
                     call string_output
                     lea  di,checkID
                     call string_input
                     call read_from_file
                     jmp  ext

    update_data:     
                     lea  dx, updatemsg
                     mov  ah,09
                     int  21h

                     call new_line
                     lea  dx,promptID
                     call string_output
                     lea  di,checkID
                     call string_input
                     call update_in_file

                     lea  dx,update_done
                     mov  ah,09
                     int  21h
                     jmp  ext




    delete_data:     
                     lea  dx, deletemsg
                     mov  ah,09
                     int  21h
                     call new_line

                     lea  dx,promptID
                     call string_output
                     lea  di,checkID
                     call string_input

                     call delete_from_file

                     lea  dx, delete_done
                     mov  ah,09
                     int  21h

    ext:             
                     lea  dx,exitmsg
                     mov  ah,09
                     int  21h

                     mov  ah,4ch
                     int  21h
main endp                                      ;Ending of Main.........................





    ;Taking input of string from user.................
string_input proc
                     mov  cx,0
    aa:              mov  ah,01h
                     int  21h
                     cmp  al,13
                     je   exit
                     mov  [di],al
                     inc  cx
                     inc  di
                     jmp  aa
                       
    exit:            ret
string_input endp



    ; Printing the string on the console......................
string_output proc
                     mov  ah,09h
                     int  21h
                     ret
string_output endp



    ;buffer to file...........
file_output proc
                     mov  ah,40h
                     mov  bx,handle
                     int  21h
                     ret
file_output endp



    ;file to buffer............
file_input proc
                     mov  ah,3fh
                     mov  bx,handle
                     int  21h
                     ret
file_input endp


    ;New line function..................
new_line proc
                     mov  dl,10
                     mov  ah,02h
                     int  21h
                     mov  dl,13
                     mov  ah,02h
                     int  21h
                     ret
new_line endp



read_from_file proc

    ;opening existing file
                     lea  dx,fname
                     mov  ah,3dh
                     mov  al,0
                     int  21h
                     mov  handle,ax

    ;first medicine record................
    ;reading Mdeiine ID from file
                     mov  cx,29d
                     lea  dx,idU1
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_input

                     lea  si,checkID
                     lea  di,idU1
                     mov  cx,4d
                     jmp  check1
    move1:           dec  cx
                     inc  si
                     inc  di
                     cmp  cx,0
                     je   equal1
    check1:          mov  al,[si]
                     cmp  al,[di]
                     je   move1
                     jmp  nequal2
    equal1:          lea  dx,idU1
                     call string_output
                     call new_line
                     lea  dx,nameU1
                     call string_output
                     call new_line
                     lea  dx,priceU1
                     call string_output
                     jmp  end1

    ;second medicine record..............
    ;reading medicine ID from file
    nequal2:         mov  cx,29d
                     lea  dx,idU2
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_input

                     lea  si,checkID
                     lea  di,idU2
                     mov  cx,4d
                     jmp  check2
    move2:           dec  cx
                     inc  si
                     inc  di
                     cmp  cx,0
                     je   equal2
    check2:          mov  al,[si]
                     cmp  al,[di]
                     je   move2
                     jmp  nequal3
    equal2:          lea  dx,idU2
                     call string_output
                     call new_line
                     lea  dx,nameU2
                     call string_output
                     call new_line
                     lea  dx,priceU2
                     call string_output
                     jmp  end1
    ;third medicine record..............
    ;reading Medicine ID from file
    nequal3:         mov  cx,29d
                     lea  dx,idU3
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_input
    ;reading Price from file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_input
                      
                     lea  si,checkID
                     lea  di,idU3
                     mov  cx,4d
                     jmp  check3
    move3:           dec  cx
                     inc  si
                     inc  di
                     cmp  cx,0
                     je   equal3
    check3:          mov  al,[si]
                     cmp  al,[di]
                     je   move3
                     jmp  nequal4
    equal3:          lea  dx,idU3
                     call string_output
                     call new_line
                     lea  dx,nameU3
                     call string_output
                     call new_line
                     lea  dx,priceU3
                     call string_output
                     jmp  end1
    ;forth medicine record..............
    ;reading Medicine ID from file
    nequal4:         mov  cx,29d
                     lea  dx,idU4
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_input

                     lea  si,checkID
                     lea  di,idU4
                     mov  cx,4d
                     jmp  check4
    move4:           dec  cx
                     inc  si
                     inc  di
                     cmp  cx,0
                     je   equal4
    check4:          mov  al,[si]
                     cmp  al,[di]
                     je   move4
                     jmp  nequal5

    equal4:          lea  dx,idU4
                     call string_output
                     call new_line
                     lea  dx,nameU4
                     call string_output
                     call new_line
                     lea  dx,priceU4
                     call string_output
                     jmp  end1


    ;fifth medicine record..............
    ;reading medicine ID from file
    nequal5:         mov  cx,29d
                     lea  dx,idU5
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_input
    ;reading Price from file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_input

                     lea  si,checkID
                     lea  di,idU4
                     mov  cx,4d
                     jmp  check5
    move5:           dec  cx
                     inc  si
                     inc  di
                     cmp  cx,0
                     je   equal5
    check5:          mov  al,[si]
                     cmp  al,[di]
                     je   move5
                     jmp  neql

    equal5:          lea  dx,idU5
                     call string_output
                     call new_line
                     lea  dx,nameU5
                     call string_output
                     call new_line
                     lea  dx,priceU5
                     call string_output
                     jmp  end1

    neql:            
                     lea  dx,notFound
                     call string_output
    ;closing of file
    end1:            mov  dx,handle
                     mov  ah,3eh
                     int  21h
                     ret
read_from_file endp


    ;delete function
delete_from_file proc

    ;opening existing file
                     lea  dx,fname
                     mov  ah,3dh
                     mov  al,0
                     int  21h
                     mov  handle,ax
    ;first medicine
    ;reading medicine ID from file
                     mov  cx,29d
                     lea  dx,idU1
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_input

    ;second medicine
    ;reading ID from file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_input
    ;third medicine
    ;reading ID from file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_input
    ;forth medicine
    ;reading ID from file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_input


    ;fifth medicine
    ;reading ID from file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_input
    ;closing file
                     mov  dx,handle
                     mov  ah,3eh
                     int  21h

    ;creating new file to delete a record

                     lea  dx,fname
                     mov  ah,3ch
                     mov  cl,1
                     int  21h
                     mov  handle,ax

    ;checking first ID
                     lea  si,checkID
                     lea  di,idU1
                     jmp  blo12
    az12:            inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   neq22
    blo12:           mov  al,[si]
                     cmp  al,[di]
                     je   az12
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU1
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_output

    ;comparing second  ID
    neq22:           lea  si,checkID
                     lea  di,idU2
                     jmp  blo22
    az22:            inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   neq33
    blo22:           mov  al,[si]
                     cmp  al,[di]
                     je   az22
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_output
    ;comparing third ID
    neq33:           lea  si,checkID
                     lea  di,idU3
                     jmp  blo33
    az33:            inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   neq44
    blo33:           mov  al,[si]
                     cmp  al,[di]
                     je   az33
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_output
    ;comparing fourth ID
    neq44:           lea  si,checkID
                     lea  di,idU4
                     jmp  blo44
    az44:            inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   neq55
    blo44:           mov  al,[si]
                     cmp  al,[di]
                     je   az44
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_output



    ;comparing fourth ID
    neq55:           lea  si,checkID
                     lea  di,idU5
                     jmp  blo55
    az55:            inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   eeeee
    blo55:           mov  al,[si]
                     cmp  al,[di]
                     je   az55
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_output
                 
    ;closing of file
    eeeee:           mov  dx,handle
                     mov  ah,3eh
                     int  21h
                     ret
delete_from_file endp
update_in_file proc

    ;opening existing file
                     lea  dx,fname
                     mov  ah,3dh
                     mov  al,0
                     int  21h
                     mov  handle,ax
    ; first medicine
    ;reading ID from file
                     mov  cx,29d
                     lea  dx,idU1
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_input

    ;medicine two
    ;reading id number from file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_input
    ;third medicine
    ;reading ID from file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_input
    ;forth medicine
    ;reading ID from file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_input


    ;fifth medicine
    ;reading id number from file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_input
    ;reading name from file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_input
    ;reading price from file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_input

    ;closing file
                     mov  dx,handle
                     mov  ah,3eh
                     int  21h

    ;creating new file to update a record

                     lea  dx,fname
                     mov  ah,3ch
                     mov  cl,1
                     int  21h
                     mov  handle,ax

    ;input name from user
                     lea  dx,strName
                     call string_output
                     lea  di,medicineName
                     call string_input
    ;input price from user
                     lea  dx,strPrice
                     call string_output
                     lea  di, medicinePrice
                     call string_input

    ;checking first id ...............................
                     lea  si,checkID
                     lea  di,idU1
                     jmp  blo111
    az111:           inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   eql1
    blo111:          mov  al,[si]
                     cmp  al,[di]
                     je   az111
                     jmp  neq222
    ;first medicine
    ;writing id number in file
    eql1:            mov  cx,29d
                     lea  dx,checkID
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,medicineName
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,medicinePrice
                     call file_output
    ;second medicine
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_output
    ;medicine two
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_output
    ;forth medicine
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_output


    ;fifth medicine
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_output







    ;comparing second ID........................
    neq222:          lea  si,checkID
                     lea  di,idU2
                     jmp  blo222
    az222:           inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   eql2
    blo222:          mov  al,[si]
                     cmp  al,[di]
                     je   az222
                     jmp  neq333
    ;medicine 1
    ;writing id in file
    eql2:            mov  cx,29d
                     lea  dx,idU1
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_output
    ;two mediine
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,checkID
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,medicineName
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,medicinePrice
                     call file_output

    ;medicine third
    ;writing id  in file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_output
    ;medicine 4
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_output


    ;medicine 5
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_output

    ;comparing third id number**************
    neq333:          lea  si,checkID
                     lea  di,idU3
                     jmp  blo333
    az333:           inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   eql3
    blo333:          mov  al,[si]
                     cmp  al,[di]
                     je   az333
                     jmp  neq444
    ;medicine 4
    ;writing id number in file
    eql3:            mov  cx,29d
                     lea  dx,idU1
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_output
    ;medicine 2
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_output
    ;medicine 3
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,checkID
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,medicineName
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,medicinePrice
                     call file_output
    ;medicine 4
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_output

    
    ;medicine 5
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_output

    ;comparing fourth id number*******************
    neq444:          lea  si,checkID
                     lea  di,idU4
                     jmp  blo444
    az444:           inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   eql4
    blo444:          mov  al,[si]
                     cmp  al,[di]
                     je   az444
                     jmp  neq555
     
    ;medicine 4
    ;writing id number in file
    eql4:            mov  cx,29d
                     lea  dx,idU1
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_output
    ;medicine 2
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_output
    ;medicine 3
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_output
    ;medicine 4
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,checkID
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,medicineName
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,medicinePrice
                     call file_output

    
    ;medicine 5
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_output


    ;comparing fourth id number*******************
    neq555:          lea  si,checkID
                     lea  di,idU5
                     jmp  blo555
    az555:           inc  si
                     inc  di
                     mov  al,32
                     cmp  al,[si]
                     je   eql5
    blo555:          mov  al,[si]
                     cmp  al,[di]
                     je   az555
                     jmp  eeeeee
     
    ;medicine 4
    ;writing id number in file
    eql5:            mov  cx,29d
                     lea  dx,idU1
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_output
    ;medicine 2
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_output
    ;medicine 3
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_output


    ;medicine 4
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_output
    ;medicine 5
    ;writing id number in file
                     mov  cx,29d
                     lea  dx,checkID
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,medicineName
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,medicinePrice
                     call file_output
                 
    ;closing of file
    eeeeee:          mov  dx,handle
                     mov  ah,3eh
                     int  21h
                     ret
update_in_file endp

open_file proc
    ;opening existing file
                     lea  dx,fname
                     mov  ah,3dh
                     mov  al,1                 ;write mode............
                     int  21h
                     mov  handle,ax
    ;for first medicine
    ;writing ID  in file
                     mov  cx,29d
                     lea  dx,idU1
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU1
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU1
                     call file_output
    ;for second medicine
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU2
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU2
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU2
                     call file_output
    ;for third medicine
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU3
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU3
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU3
                     call file_output
    ;for forth medicine
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU4
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU4
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU4
                     call file_output


    ;for fifth medicine
    ;writing ID in file
                     mov  cx,29d
                     lea  dx,idU5
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,nameU5
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,priceU5
                     call file_output
    ;closing of file
                     mov  dx,handle            ;closing file
                     mov  ah,3eh
                     int  21h
                     ret
open_file endp

input_form_user proc
                     call new_line
    ;input ID form user
                     lea  dx, strID
                     call string_output

                     lea  di,medicineID
                     call string_input
                        
    ;input name from user
                     lea  dx, strName
                     call string_output
                     lea  di,medicineName
                     call string_input
                        
    ;input price from user
                     lea  dx, strPrice
                     call string_output
                     lea  di, medicinePrice
                     call string_input
                        
                     ret
input_form_user endp

writing_in_file proc
                     call input_form_user

    ;opening existing file
                     lea  dx,fname
                     mov  ah,3dh
                     mov  al,1                 ;write mode........
                     int  21h

                     mov  handle,ax

                     mov  bx,handle
                     mov  ah,42h
                     xor  cx,cx
                     xor  dx,dx
                     mov  al,2
                     int  21h

    ;writing ID in file
                     mov  cx,29d
                     lea  dx,medicineID
                     call file_output
    ;writing name in file
                     mov  cx,29d
                     lea  dx,medicineName
                     call file_output
    ;writing price in file
                     mov  cx,29d
                     lea  dx,medicinePrice
                     call file_output
    ;closing of file
                     mov  dx,handle
                     mov  ah,3eh
                     int  21h
                     ret
writing_in_file endp
end main
