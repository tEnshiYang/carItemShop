

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
	
<div class="payedDiv">
	<div class="payedTextDiv">
		<img src="img/site/paySuccess.png">
		<span>您已提交订单</span> 
		
	</div>
	<div class="payedAddressInfo">
		<ul>
			<li>收货地址：${o.address} ${o.receiver} ${o.mobile }</li>
			<li>总价：<span class="payedInfoPrice">
			￥<fmt:formatNumber type="number" value="${param.total}" minFractionDigits="2"/>
			</li>
			
		</ul>
				
		<div class="paedCheckLinkDiv">
			
			
			<a class="payedCheckLink" href="forebought">查看交易详情 </a>
		</div>
			
	</div>
	
	<div class="payedSeperateLine">
	</div>


	

</div>