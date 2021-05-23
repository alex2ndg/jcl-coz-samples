//JOBLIB    DD DISP=SHR,DSN=TEST.COZ.LOADLIB
//*
//*---------------------------------Co-Z Variables
//* %%SET %%PATH=/tmp   Remote path for Unix
//* %%SET %%HOST=test.server.org    Destination Unix Server
//* %%SET %%FILE=PROD.TEST.FILE.TOSEND.SFTP   File to be sent
//*
//PUTFTP1 EXEC PGM=COZBATCH                                              
//SYSPRINT DD SYSOUT=*                                                   
//OUTPUT   DD SYSOUT=*                                                   
//*
//*---------------------------------Credentials SYSIN contains the *nix
//*- username, such as:
//*- user="sftp_username"
//*- pwdsn='//ORG.TEST.SYSIN(PASSWORD)'
//*- ... and on the PASSWORD SYSIN you'll have the plain-text password.
//*
//STDIN    DD DSN=ORG.TEST.SYSIN(CREDENTIALS),DISP=SHR   
//*
//*---------------------------------Co-Z Definitions
//*- host: hostname of the final destination servers
//*- path: destination path of the *nix server.
//*- opt: options for the transfer:
//*   mode(text/binary) for ascii/binary)
//*   linerule (cr/lf/crlf) for carriage return logic
//*   clientcp for zOS codepage - check https://www.ibm.com/docs/en/zos/2.1.0?topic=pages-summary-tables-code
//*   servercp for *nix codepage
//*   notrim to allow whitespaces and low values at right
//*   localf for zOS local file to share. to start always with //
//*   EOB marks the logic of the commands to be launched via CoZ. lzopts will load the previous $opt variables explained.
//*
//         DD *                        
host="%%HOST"    
path="%%PATH"      
opt="mode=text,linerule=crlf,clientcp=IBM-284,servercp=ISO8859-1,notrim" 
localf="//%%FILE"   
. sftp_connection.sh << EOB       
lzopts $opt   
cd $path     
put $localf %%FILE  
EOB
