
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
	
<div class="confirmPayPageDiv">

	<div class="confirmPayOrderInfoDiv">
		<div class="confirmPayOrderInfoText">我已收到货</div>
	</div>
	<div class="confirmPayOrderItemDiv">
		<div class="confirmPayOrderItemText">订单信息</div>
		<table class="confirmPayOrderItemTable">
			<thead>
				<th colspan="2">宝贝</th>		
				<th width="120px">单价</th>		
				<th width="120px">数量</th>		
				<th width="120px">商品总价 </th>		
				<th width="120px"></th>		
			</thead>
			<c:forEach items="${o.orderItems}" var="oi">
				<tr>
					<td><img width="50px" src="img/productSingle_middle/${oi.product.firstProductImage.id}.jpg"></td>
					<td class="confirmPayOrderItemProductLink">
						<a href="#nowhere">${oi.product.name}</a>
					</td>
					<td>￥<fmt:formatNumber type="number" value="${oi.product.originalPrice}" minFractionDigits="2"/></td>
					<td>1</td>
					<td><span class="conformPayProductPrice">￥<fmt:formatNumber type="number" value="${oi.product.promotePrice}" minFractionDigits="2"/></span></td>
					<td></td>
				</tr>
			</c:forEach>
		</table>
		
		<div class="confirmPayOrderItemText pull-right">
			实付款： <span class="confirmPayOrderItemSumPrice">￥<fmt:formatNumber type="number" value="${o.total}" minFractionDigits="2"/></span>
		</div>
		
		
	</div>
	<div class="confirmPayOrderDetailDiv">
		
		<table class="confirmPayOrderDetailTable">
			<tr>
				<td>订单编号：</td>
				<td>${o.orderCode} </td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td>收货信息： </td>
				<td>${o.address}，${o.receiver}， ${o.mobile}，${o.post} </td>
			</tr>
			<tr>
				<td>成交时间：</td>
				<td><fmt:formatDate value="${o.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
			</tr>
		</table>
		
	</div>
	<div class="confirmPayButtonDiv">
		<a href="foreorderConfirmed?oid=${o.id}"><button class="confirmPayButton">确认收货</button></a>
	</div>
</div>