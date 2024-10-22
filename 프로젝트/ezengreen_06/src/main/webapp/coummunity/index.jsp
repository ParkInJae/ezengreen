<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp" %>
<%
String type    = request.getParameter("type");
String keyword = request.getParameter("keyword");
String curpage = request.getParameter("page");
String bkind = request.getParameter("kind");

if(curpage  == null) curpage  = "1";
if(type    == null) type    = "T";
if(keyword == null) keyword = "";
if(bkind   == null) bkind   = "C";

int nowpage = 1;

//(2) "index.jsp?page=2" 에서 넘어온 page를 분석한다.
if( request.getParameter("page") != null)
{
	//넘어온 page 값을 정수형 curpage 로 변환한다. 
	nowpage = Integer.parseInt(request.getParameter("page"));
}else
{
	//넘어온 page 값이 없으므로 현재 페이지 번호를 1로 설정한다. 
	nowpage = 1;
}

String title = "";
switch(bkind)
{
	case "N" : title = "공지사항";		break;
	case "S" : title = "경기일정";		break;
	case "C" : title = "자유게시판";	break;
	case "G" : title = "갤러리";		break;
}

BoardDTO bdto = new BoardDTO();

//전체 게시물 갯수를 조회한다.
int total = bdto.GetTotal(bkind, type, keyword);

//최대 페이지 번호를 계산한다.
int maxpage = total / 10;
if( total % 10 != 0) maxpage++;

String sql = "";

//게시물 목록을 조회한다.
ArrayList<BoardVO> list = bdto.GetList(nowpage, bkind, type, keyword);
%>
<style>

.maintable > *
{
	font-size : 10pt;
	background-color : white;
}

</style>
<table border="0" width="100%" height="430px">
	<tr>
		<td>    
			<table border="1" style="width:100%; height:100%; text-align:center; border : 1px solid black; border-collapse : collapse;" class="maintable">
				<tr>
					<td colspan="5">
						<b style="float:left; font-size: 14pt; font-weight: 900;">&nbsp;자유게시판</b>
						<form id="search" name="search" method="get" action="index.jsp">
						<input type="hidden" id="kind" name="kind" value="<%= bkind %>">
							<select id="type" name="type">
								<option value="T" <%= type.equals("T") ? "selected" : "" %>>제목</option>
								<option value="N" <%= type.equals("N") ? "selected" : "" %>>내용</option>
								<option value=""  <%= type.equals("") ? "selected" : "" %>>작성자</option>
							</select>
						<input type="text" id="keyword" name="keyword" value="<%= keyword %>">
						<input type="submit" value="검색">
						<%
						if(login != null )
						{
							%>
							<input type="button" style="float: right;" value="글쓰기" onClick="location.href='write.jsp?page=<%= nowpage %>'">
							<%
						}else
						{
							%>
							<input type="button" style="float: right;" value="글쓰기" onClick="javascript:alert('글쓰기 권한이 없습니다.');">&nbsp;&nbsp;
							<%				 
						}
						%>
						</form>		
					</td>
				</tr>
				<tr>
            		<td style="font-weight: 650;" width="40px">번호</td>
            		<td style="font-weight: 650;">제목</td>
            		<td style="font-weight: 650;" width="60px">작성자</td>
            		<td style="font-weight: 650;" width="100px">작성일</td>
            		<td style="font-weight: 650;" width="50px">조회수</td>
				</tr>
				<%
				int seqNo = total - ((nowpage-1) * 10);
				for(BoardVO vo : list)
				{
					String sub_title = vo.getBtitle();
					int    max_length = 26;
					if(sub_title.length() > max_length)
					{
						sub_title = sub_title.substring(0,max_length) + "...";
					}					
					%>
					<tr>
						<td style="text-align:center;"><%= seqNo-- %></td>
						<td style="text-align:left;">
							<a href="view.jsp?no=<%= vo.getBno() %>&kind=<%= bkind %>&page=<%= nowpage %>">
							<div class='txt' title="<%=vo.getBtitle() %>"><%= sub_title %>&nbsp;
							<%
							if(!vo.getRno().equals("0"))
							{
								%>(<span style="color:#ff6600"><%= vo.getRno() %></span>)<%
							}
							%>						
							</div></a>
						</td>
						<td style="text-align:center;"><%= vo.getUname() %></td>
						<td style="text-align:center;"><%= vo.getBwdate() %></td>
						<td style="text-align:center;"><%= vo.getBhit() %></td>
					</tr>
					<%
				}
				//마지막 빈행 추가
				int remainingRows = 10 - (total % 10); // 남은 행의 갯수 계산(총 게시물 갯수 10으로 나눈 나머지 )
				if (nowpage == maxpage && remainingRows != 0 && remainingRows != 10) 	//현재 페이지가 최대 페이지고 남은 행이 0보다 클때(마지막이 딱 나눠 떨어지지 않을때)
				{
		            for (int i = 0; i < remainingRows; i++) 
		            {
		                %>
		                <tr>
		                    <td style="text-align:center; border: 0;" colspan="5">&nbsp;</td>
		                </tr>
		                <%
					}
				}else if(list.size() == 0)
				{
					for(int i = 1; i <= 10; i++)
					{
						%>
		                <tr>
		                    <td style="text-align:center; border: 0;" colspan="5">&nbsp;</td>
		                </tr>
		                <%
	            	}
				}
				
				if(list.size() != 0)
				{
					%>
	              	<tr>
	              		<td colspan="5" align="center">
	              		<!-- 1 2 3 4 5 -->
	              		<%
	            		//(5)페이징 시작블럭번호와 끝블럭 번호를 계산한다
	            		int startBlock = ( (nowpage - 1)  / 5) * 5 + 1;	//괄호안에 값들만 먼저 정수로 변환
	            		int endBlock   = startBlock + 5 - 1; 
	            		
	            		//(6)endBlock 이 최대 페이지 번호보다 크면 안됨.
	            		if( endBlock > maxpage)
	            		{
	            			//예: maxpage가 22인데, endBlock이 30이면 endBlock을 22로 변경
	            			endBlock = maxpage;
	            		}
	            		
	            		//(9)이전 페이지 블럭을 표시한다.
	            		if(startBlock != 1)
	            		{
	            			%>
	            			<a href="index.jsp?type=<%= type %>&keyword=<%= keyword %>&kind=<%= bkind %>&page=<%= startBlock - 1 %>">◀</a>&nbsp;
	            			<%
	            		}
	            		
	            		//(7)화면에 블럭 페이징을 표시한다.
	            		for(int pageno = startBlock ; pageno <= endBlock; pageno++)
	            		{
	            			if( nowpage == pageno)
	            			{
	            				//현재 페이지 이면....
	            				%>
	            				<a href="index.jsp?type=<%= type %>&keyword=<%= keyword %>&kind=<%= bkind %>&page=<%= pageno %>"><b style="color:green;"><%= pageno %></b></a>&nbsp;
	            				<%
	            			}else
	            			{
	            				%>
	            				<a href="index.jsp?type=<%= type %>&keyword=<%= keyword %>&kind=<%= bkind %>&page=<%= pageno %>"><%= pageno %></a>&nbsp;
	            				<%
	            			}
	            		}
	            		
	            		//(8)다음 페이지 블럭을 표시한다.
	            		if(endBlock < maxpage)
	            		{
	            			%>
	            			<a href="index.jsp?type=<%= type %>&keyword=<%= keyword %>&kind=<%= bkind %>&page=<%= endBlock + 1 %>">▶</a>&nbsp;
	            			<%
	            		}
	
	              		%>
	              		</td>
	              	</tr>
	              	<%
              	}else
              	{
              		%>
              		<tr>
              			<td colspan="5" align="center"><b style="color:green;">1</b></td>
              		</tr>
              		<%
              	}
			 	%>
			</table>
		</td>
	</tr>
</table>
<%@ include file="include/tail.jsp" %>