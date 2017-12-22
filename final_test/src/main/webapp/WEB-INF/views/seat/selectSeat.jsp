<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>좌석 선택</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/seat/selectSeat.css" rel="stylesheet">
<script type="text/javascript">
	$(function(){
		var count=0;
		/* 남은좌석 관련해서 추가 할 것  숫자*/
		/* 이미 판매된 좌석 관련해서도 작업할것 */
		/* 좌석 배치도 열 이름 출력 하는 부분 */
		$(".row").each(function(){
			var row=Number($(this).attr("title"));
			var i=64;
			i+=row;
			var english = String.fromCharCode(i);
			$('#'+row).attr("value", english+'열');
		});
		/* 좌석 배치도 선택관련 부분 */
		$(".seat_span").each(function(){
			var id=$(this).attr("title");
			$('#'+id).click(function(){
				var color=$('#'+id).css('background-color');
				if(count<'${ticket}'||color=='rgb(255, 0, 0)'){
					if(color=='rgb(255, 0, 0)'){
						count--;
						if(count<0){
							count=0;
						}
						$('#'+id).css('background-color', '#666');
					}else{					
						count++;
						$('#'+id).css('background-color', 'red');
					}
				}
				$('#select').attr("value", count);
			});
			$('#select').attr("value", count);
		});
		/* 결제 API 부분 */
		$("#btn").click(function(){
			if(count=='${ticket}'){
				var IMP = window.IMP; /*생략가능 */
				IMP.init('imp95781276');/* 가맹점 식별 코드 변경하지 마세요.*/
				
				IMP.request_pay({
					pg : 'inicis', /* version 1.1.0부터 지원 */
					pay_method : 'card',
					merchant_uid : 'merchant_' + new Date().getTime(),
					name : '김종욱 찾기', /* 나중에 공연명 데이터 받아오는걸로 변경 할 것 */
					amount : 25000, /* 나중에 총 금액 데이터 받아오는걸로 변경 할 것 */
					buyer_email : 'test@test.com', /* 나중에 회원 정보에서 이메일 받아오는 걸로 변경할 것 */
					buyer_tel : '010-1234-5678', /* 나중에 회원 정보에서 연락처 받아오는 걸로 변경 할 것 */
					buyer_addr : '서울특별시 강남구 삼성동',/* mediabank에서 값을 안받알때 어떻게 진행했는지 확인 할것 */
					buyer_postcode : '123-456', /* 위와 동일 */
					m_redirect_url : 'https://www.yourdomain.com/payments/complete'
				},function(rsp){
					if(rsp.success){
						var msg = rsp.paid_amount+'결제가 완료 되었습니다.';
						/* 이후 결제 완료된 부분을 보여주는 페이지로 이동하는거 추가 할 것 */
					}else{
						var msg = '결제에 실패하였습니다.';
						msg += '에러내용 : '+rsp.error_msg;
					}
					alert(msg);
				});	
			}else{
				alert('좌석을 선택하세요.');
			}
		});
		
	});
</script>
</head>
<body>
<div class="body">
<!-- header -->
<!-- Contents Start -->
	<div class="totalbody">
		<div class="title">
			<h1>김종욱 찾기</h1> <span>대학로 | 쁘띠첼씨어터 | 남은좌석</span> <span id="anySeat">25</span><span>/25 | 구매 장수 <input id="select" type="number" readonly="readonly"/>/${ticket}</span> 
			<h1 class="date">2017.12.21(목) 오후 6시</h1>
		</div>
		
		<div class="seat">
			<div class="stage">
					<span>STAGE</span>
			</div>
			<table class="seat_contents">
				<c:forEach begin="1" end="${row}" var="i">
					<tr>
						<td class="row" title="${i}"><input type="text" readonly="readonly" id="${i}"></td>
						<c:forEach begin="1" end="${col}" var="j">
							<td>
								<span class="seat_span" title="r${i}c${j}" id="r${i}c${j}">${j}</span>
							</td>
						</c:forEach>
					</tr>
				</c:forEach>
			</table>
		</div>
		<div id="btn_div">
			<button id="btn"></button>		
		</div>
	</div>
	
<!-- Contents End -->
<!-- footer -->
</div>
</body>
</html>