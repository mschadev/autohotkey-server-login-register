#include ../../ServerLib.ahk
#include ../../ServerLib_A.ahk
License := new Server_A("ID","PW")
MsgBox,% License.License("test1234","2019-03-29")