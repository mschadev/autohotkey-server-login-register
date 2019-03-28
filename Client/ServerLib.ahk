class Server
{
    _URL := "http://faumes.com/Server/" ;Server URL
    _Name := "Server"
    _ID := "" ;ID
    _PW := "" ;PW
    __New(ID,PW){
        this._ID := ID
        this._PW := PW
    }
    __Delete(){
        
    }
    ResetPassword(){
        if(this.Login() != true){
            return false
        }
        winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        URL := this._URL "resetpasswordrequest.php"
        winHttp.SetTimeouts(0,60000,30000,120000)
        winHttp.Open("POST",URL)
        winHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        winHttp.SetRequestHeader("User-Agent","System-" this._Name "-resetpassword")

        postData := "id=" this._ID "&"
        postData .= "securitycode=" this.SHA512(this.MakeSecurityCode() "System-" this._Name "-resetpassword" "resetpassword")
        winHttp.SetRequestHeader("Content-Length",StrLen(postData))
        
        winHttp.Send(postData)
        winHttp.WaitForResponse()

        Result := winHttp.ResponseText
        Result := Trim(Result)
        MsgBox,%Result%
    }
    Register(Name,Email){
        winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        URL := this._URL "register.php"
        winHttp.Open("POST",URL)
        winHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        winHttp.SetRequestHeader("User-Agent","System-" this._Name "-Register")

        postData := "id=" this._ID "&"
        postData .= "password=" this._PW "&"
        postData .= "email=" Email "&"
        postData .= "name=" Name "&"
        postData .= "securitycode=" this.SHA512(this.MakeSecurityCode() "System-" this._Name "-Register")

        winHttp.SetRequestHeader("Content-Length",StrLen(postData))
        
        winHttp.Send(postData)
        winHttp.WaitForResponse()

        Result := winHttp.ResponseText
        Result := Trim(Result)
        IfInString, Result,회원가입
        {
            return true
        }
        else{
            MsgBox,%Result%
            return false
        }
       
    }
    Login(){
        winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        URL := this._URL "login.php"
        winHttp.Open("POST",URL)
        winHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        winHttp.SetRequestHeader("User-Agent","System-" this._Name "-Login")

        postData := "id=" this._ID "&"
        postData .= "password=" this._PW "&"
        postData .= "hardnumber=" Trim(this.GetHddPh(0)) "&"
        postData .= "pcname=" A_ComputerName "&"
        postData .= "securitycode=" this.SHA512(this.MakeSecurityCode() this._ID "login")
        MsgBox,%postData%

        winHttp.SetRequestHeader("Content-Length",StrLen(postData))
        
        winHttp.Send(postData)
        winHttp.WaitForResponse()

        Result := winHttp.ResponseText
        StringGetPos, offSet,Result,=
        StringGetPos,index,Result,>
        Result := Trim(Result)
        Result := SubStr(Result,offSet+3,Strlen(Result)-offSet-4)

        FormatTime, Time,yyyyMMddHHmm,yyyyMMddHHmm
        ;MsgBox,%Result%
        if(Result=this.SHA512(SubStr(Time,1,StrLen(Time)-1) this._ID "NotLicense")) ;라이센스 없음
        {
            return -1
        }
        else if(Result=this.SHA512(SubStr(Time,1,StrLen(Time)-1) this._ID "wrong")) ;로그인 실패
        {
            return false
        }
        else if(Result=this.SHA512(SubStr(Time,1,StrLen(Time)-1) this._ID "alright")) ;로그인 성공
        {
            return true
        }
        else
        {
            return Result
        }
    }
    MakeSecurityCode(){
        FormatTime, Time,yyyyMMddHHmm,yyyyMMddHHmm
        return SubStr(Time,1,StrLen(Time)-1)
    }
    SHA512(String,Encoding="UTF-8"){
        return this.CalcStringHash(String,0x800e,Encoding)
    }
    GetHddPh(Number){
    for objItem in ComObjGet("winmgmts:\\.\root\cimv2").ExecQuery("SELECT * FROM Win32_PhysicalMedia WHERE Tag = '\\\\.\\PHYSICALDRIVE" Number "'", "WQL", 0x10 + 0x20)
    return objItem.SerialNumber
    }

    ; CalcStringHash ====================================================================
    CalcStringHash(string, algid, encoding = "UTF-8", byref hash = 0, byref hashlength = 0)
    {
    chrlength := (encoding = "CP1200" || encoding = "UTF-16") ? 2 : 1
    length := (StrPut(string, encoding) - 1) * chrlength
    VarSetCapacity(data, length, 0)
    StrPut(string, &data, floor(length / chrlength), encoding)
    return this.CalcAddrHash(&data, length, algid, hash, hashlength)
    }
    ; CalcAddrHash ======================================================================
CalcAddrHash(addr, length, algid, byref hash = 0, byref hashlength = 0)
{
    static h := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "a", "b", "c", "d", "e", "f"]
    static b := h.minIndex()
    hProv := hHash := o := ""
    if (DllCall("advapi32\CryptAcquireContext", "Ptr*", hProv, "Ptr", 0, "Ptr", 0, "UInt", 24, "UInt", 0xf0000000))
    {
        if (DllCall("advapi32\CryptCreateHash", "Ptr", hProv, "UInt", algid, "UInt", 0, "UInt", 0, "Ptr*", hHash))
        {
            if (DllCall("advapi32\CryptHashData", "Ptr", hHash, "Ptr", addr, "UInt", length, "UInt", 0))
            {
                if (DllCall("advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", 0, "UInt*", hashlength, "UInt", 0))
                {
                    VarSetCapacity(hash, hashlength, 0)
                    if (DllCall("advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", &hash, "UInt*", hashlength, "UInt", 0))
                    {
                        loop % hashlength
                        {
                            v := NumGet(hash, A_Index - 1, "UChar")
                            o .= h[(v >> 4) + b] h[(v & 0xf) + b]
                        }
                    }
                }
            }
            DllCall("advapi32\CryptDestroyHash", "Ptr", hHash)
        }
        DllCall("advapi32\CryptReleaseContext", "Ptr", hProv, "UInt", 0)
    }
    return o
}
}