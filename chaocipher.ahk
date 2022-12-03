; ====================================================
; ================ AHK CHAOCIPHER GUI ================
; ====================================================
; AutoHotKey version: 1.1.35.0
; Language:           English
; Author:             Pedro F. Albanese
; Modified:           -
;
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

LeftW := "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
RghtW := "PTLNBQDEOYSFAVZKGJRIHWXUMC"

#NoEnv
SetBatchLines, -1
Gui, Margin, 20, 10
Gui, Font, s10, Courier New
Gui, Add, Edit, w600 r10 vInput
Gui, Font
Gui, Add, Button, gEncode, Encode
Gui, Add, Button, x+m yp gDecode, Decode
Gui, Font, s10, Courier New
Gui, Add, Edit, xm w600 r10 vResult +ReadOnly
Gui, Show, , CHAOCIPHER
Return

GuiClose:
ExitApp

Encode:
Gui, Submit, NoHide
GuiControl, , Result, % Chao_Cipher(Input, LeftW, RghtW)
Return

Decode:
Gui, Submit, NoHide
GuiControl, , Result, % Chao_Decipher(Input, LeftW, RghtW)
Return

;-------------------------------------------
Chao_Cipher(PT, LeftW, RghtW){
    oRght:=StrSplit(RghtW), oLeft:=StrSplit(LeftW)
    for i, p in StrSplit(PT){
        result .= (c := Key2Val(oRght, oLeft, p))
        oLeft:=Permute(oLeft, c, 1)
        oRght:=Permute(oRght, p)
    }
    return result
}
;-------------------------------------------
Chao_Decipher(CT, LeftW, RghtW){
    oRght:=StrSplit(RghtW), oLeft:=StrSplit(LeftW)
    for i, c in StrSplit(CT){
        result .= (p := Key2Val(oLeft, oRght, c))
        oLeft:=Permute(oLeft, c, 1)
        oRght:=Permute(oRght, p)
    }    
    return result
}
;-------------------------------------------
Key2Val(Key, Val, char){
    for i, ch in Key
        if (ch = char)
            return Val[i]
}
;-------------------------------------------
Permute(Arr, ch, dt:=0){
    for i, c in Arr
        if (c=ch)
            break
    loop % i-dt
        Arr.Push(Arr.RemoveAt(1))               ; shift left
    ch := Arr[3-dt]                             ; save 2nd/3rd chr
    loop % 11+dt
        Arr[A_Index+2-dt]:=Arr[A_Index+3-dt]    ; shift pos 3/4-14 left
    Arr[14] := ch                               ; place 2nd/3rd chr in pos 14
    return Arr
}