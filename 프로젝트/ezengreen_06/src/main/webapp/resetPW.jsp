<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp"%>
<%

String uname  = request.getParameter("uname");
String uid    = request.getParameter("uid");
String uemail = request.getParameter("uemail");

%>
<script>
function viewpw()
{
    eye.addEventListener('mousedown', (event) =>{
    	reupw.type = 'text';
	});
    eye.addEventListener('mouseup', (event) =>{
    	reupw.type = 'password';
	});
}

window.onload = function () 
{
    document.resetPW.reupw.focus();

    $("#reupwcheck").keyup(function () 
    {
        IsDuplicate = false;

        userpw = $("#reupw").val(); // 비밀번호 입력값 가져오기
        userpwcheck = $("#reupwcheck").val(); // 비밀번호 확인 입력값 가져오기

        if(userpwcheck == "") 
        {
            $("#spanMsg").html("비밀번호를 입력하세요.");
            return;
        }

        // 비밀번호와 비밀번호 확인값 비교하기
        if (userpw === userpwcheck) 
        {
            $("#spanMsg").html("비밀번호가 일치합니다.");
            $("#spanMsg").css("color", "blue");
        }else {
            $("#spanMsg").html("비밀번호가 일치하지 않습니다.");
            $("#spanMsg").css("color", "red");
        }
    });

    // 비밀번호 확인 입력란의 값이 변경될 때마다 비밀번호 일치 여부를 확인하는 함수 호출
    $("#reupwcheck").trigger("keyup");
}
function resetpw()
{
	if( document.resetPW.reupw.value == "" )
	{
		alert("비밀번호를 입력하세요.");
		document.resetPW.reupw.focus();
		return false;
	}
	if( document.resetPW.reupw.value != document.resetPW.reupwcheck.value )
	{
		alert("비밀번호가 일치하지 않습니다.");
		document.resetPW.reupw.focus();
		return false;
	}	
	document.resetPW.submit();
	return true;
}
</script>
<form name="resetPW" id="resetPW" method="post" action="resetPWok.jsp">
	<table border="0" width="100%" height="430px" hclass="n-table" style="background-color: #f0f0f0;">
	<input type="hidden" name="uid" value="<%=uid%>">
		<tr style="height: 20px;">
			<td></td>
		</tr>
		<tr height="25px">
			<td colspan="3" style="font-weight: bold;">비밀번호 재설정 </td>
		</tr>
		<tr>
			<td colspan="3" height="1px">								
				<hr size="1" style="width: 100%; height: 1px; background-color: dimgrey">
			</td>
		</tr>
		<tr class="aaaa">
			<td colspan="3"></td>
		</tr>
		<tr class="aaaa">
			<td width="100px"></td>
			<td colspan="2" style="font-weight: bold; font-size: 13px;">비밀번호를 다시 설정해주세요</td>
		</tr>
		<tr class="aaaa" >
			<td width="100px"></td>
			<td colspan="2" style="font-size: 10px;">사용하실 새로운 비밀번호를 입력해주세요</td>
		</tr>
		<tr class="aaaa">
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr class="aaaa">
			<td></td>
			<td style="font-weight: bold; font-size: 13px; width:130px;"> 새 비밀번호</td>
			<td>
				<input type="password" id="reupw" name="reupw" style="font-weight: bold; font-size: 13px; align:left; width:250px;" placeholder="비밀번호를 입력하세요.">
				<input type="button" value="보기" id="eye" name="eye" onClick="viewpw()">
			</td>
		</tr>
		<tr class="aaaa">
			<td></td>
			<td style="font-weight: bold; font-size: 13px;"> 새 비밀번호  확인</td>
			<td>
				<input type="password" id="reupwcheck" name="reupwcheck" style="font-weight: bold; font-size: 13px; align:left; width:250px;" placeholder="비밀번호를 입력하세요.">
				<br><span style="font-size: 9pt;" id="spanMsg">비밀번호를 입력해주세요</span>
			</td>
		</tr>
		<tr class="aaaa">
			<td colspan="3"></td>
		</tr>
		<tr class="aaaa">
			<td align="center" colspan="4"> 
				 <input type="button" value="완료" onClick="resetpw();">&nbsp;
				 <input type="button" value="취소" onclick="history.back()">
			</td>
		</tr>
		<tr>
			<th colspan="3"></th>
		</tr>
	</table>     	
</form>	      
<%@ include file="include/tail.jsp" %>