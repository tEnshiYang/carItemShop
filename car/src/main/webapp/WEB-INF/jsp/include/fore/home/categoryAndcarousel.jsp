

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>



<img src="img/site/catear.png" id="catear" class="catear"/>
	
<div class="categoryWithCarousel">


<div class="headbar show1">
	<div class="head ">
	
		<span style="margin-left:10px" class="glyphicon glyphicon-th-list"></span>
		<span style="margin-left:10px" >商品分类</span>
	
	</div>
	
		<div class="rightMenu">
		

			<c:forEach items="${cs}" var="c">
			<span cid="${c.id}" class="eachCategory">
				
				<a href="forecategory?cid=${c.id}">
					${c.name}
				</a>
			</span>
		</c:forEach>
	</div>
</div>
<div>
<%@include file="carousel.jsp" %>
</div>


<div class="carouselBackgroundDiv">
</div>

</div>





