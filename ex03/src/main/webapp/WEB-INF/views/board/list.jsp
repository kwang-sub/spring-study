<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>


<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Tables</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board List Page   
                            <button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>    
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <table width="100%" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>#번호</th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                 <tr>${result}</tr>
	                                <c:forEach items="${list}" var="board">
	                                	<tr>
											<td><c:out value="${board.bno }"/></td>                                
											<td><a class="move" href="${board.bno }"><c:out value="${board.title }"/> <b>[${board.replyCnt }]</b></a></td>                                
											<td><c:out value="${board.writer }"/></td>                                
											<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate }" /></td>                                
											<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate }" /></td>                                
										</tr>
	                                </c:forEach>
                                </tbody>
                            </table>
                            <!-- /.table-responsive -->
                            
                            <!-- 검색창 -->
                            <div class="row">
                            	<div class="col-lg-12">
									<form action="/board/list" id="searchForm" method="get">
										<select name="type">
											<option value="" ${pageMaker.cri.type == null ?'selected' : '' } >--</option>
											<option value="T" ${pageMaker.cri.type eq 'T' ?'selected' : '' } >제목</option>
											<option value="C" ${pageMaker.cri.type eq 'C' ?'selected' : '' }>내용</option>
											<option value="W" ${pageMaker.cri.type eq 'W' ?'selected' : '' }>작성자</option>
											<option value="TC" ${pageMaker.cri.type eq 'TC' ?'selected' : '' }>제목 or 내용</option>
											<option value="TW" ${pageMaker.cri.type eq 'TW' ?'selected' : '' }>제목 or 작성자</option>
											<option value="TWC" ${pageMaker.cri.type eq 'TWC' ?'selected' : '' }>제목or 내용 or 작성자</option>
										</select>
										<input type="text" name="keyword" value="${pageMaker.cri.keyword }"/>
										<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
										<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
										<button class="btn btn-default">Search</button>
									</form>                            	
                            	</div>
                            </div>
                            
                            <!-- 페이징처리 -->
                            <div class="pull-right">
                            	<ul class="pagination">
                            		<c:if test="${pageMaker.prev }">
                            			<li class="paginate_button previous">
                            				<a href="${pageMaker.startPage -1}">Previous</a>
                            			</li>
                            		</c:if>
                            		<c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
										<li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : '' }">
											<a href="${num }">${num}</a>
										</li>                            		
                            		</c:forEach>
                            		<c:if test="${pageMaker.next }">
                            			<li class="paginate_button next">
                            				<a href="${pageMaker.endPage +1}">Next</a>
                            			</li>
                            		</c:if>
                            	</ul>
                            </div>
                            
                            <!-- 실제 페이징 이동을 위한 폼태그, 상세보기도 해당 폼태그 이용 -->
                            <form action="/board/list" id="actionForm" method="get">
                            	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
                            	<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                            	<input type="hidden" name="type" value="${pageMaker.cri.type }">
                            	<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
                            </form>
                            
                            <!-- modal 추가 -->
     						<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
     							<div class="modal-dialog">
     								<div class="modal-content">
     									<div class="modal-header">
     										<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
     										<h4 class="modal-title" id="myModalLaber">Modal title</h4>
     									</div>
     									<div class="modal-body">처리가 완료되었습니다.</div>
     									<div class="modal-footer">
     										<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
     										<button type="button" class="btn btn-primary" data-dismiss="modal">Save changes</button>
     									</div>
     								</div>
     							</div>
     						</div>                   
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
<script type="text/javascript">
	$(document).ready(function () {
		
		var result = '${result}';
		
		checkModal(result);
		
		/* 뒤로가기시 이전 요청 없애기 */
		history.replaceState({},null,null);
		
		/* 게시글 작성 후 modal창띄우기 */
		function checkModal(result){
			if(result === '' || history.state){
				return;
			}
			
			if(parseInt(result) > 0 ){
				$(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.")
			}
			
			$("#myModal").modal("show");
		}
		
		/* 글작성버튼 클릭시 작성페이지로 이동  */
		$("#regBtn").on("click", function () {
			self.location = "/board/register";
		})
		
		/* 페이징처리를 위한 스크립트 */
		var actionForm = $("#actionForm");
		$(".paginate_button a").on("click", function (e) {
			e.preventDefault();
			console.log("click");
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		})
		
		/* 게시물 상세보기를 위한 스크립트 */
		$(".move").on("click",function(e){
			e.preventDefault();
			actionForm.append("<input type='hidden' name='bno' value='"+ $(this).attr('href') +"'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		})
		
		/* 검색버튼 스크립트 */
		var searchForm = $("#searchForm");
		$("#searchForm button").on("click", function(e){
			if(!searchForm.find("option:selected").val()){
				alert("검색종류를 선택하세요");
				return false;
			}
			
			if(!searchForm.find("input[name='keyword']").val()){
				alert("키워드를 입력하세요")
				return false;
			}
			searchForm.find("input[name='pageNum']").val("1");
			e.preventDefault();
			searchForm.submit();
		})
	});
</script>

<%@include file="../includes/footer.jsp" %>
