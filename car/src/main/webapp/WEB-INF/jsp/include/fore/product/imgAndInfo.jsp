

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
 
$(function(){
    var stock = ${p.stock};
    $(".productNumberSetting").keyup(function(){
        var num= $(".productNumberSetting").val();
        num = parseInt(num);
        if(isNaN(num))
            num= 1;
        if(num<=0)
            num = 1;
        if(num>stock)
            num = stock;
        $(".productNumberSetting").val(num);
    });
     
    $(".increaseNumber").click(function(){
        var num= $(".productNumberSetting").val();
        num++;
        if(num>stock)
            num = stock;
        $(".productNumberSetting").val(num);
    });
    $(".decreaseNumber").click(function(){
        var num= $(".productNumberSetting").val();
        --num;
        if(num<=0)
            num=1;
        $(".productNumberSetting").val(num);
    });
     
    $(".addCartButton").removeAttr("disabled");
    $(".addCartLink").click(function(){
        var page = "forecheckLogin";
        $.get(
                page,
                function(result){
                    if("success"==result){
                        var pid = ${p.id};
                        var num= $(".productNumberSetting").val();
                        var addCartpage = "foreaddCart";
                        $.get(
                                addCartpage,
                                {"pid":pid,"num":num},
                                function(result){
                                    if("success"==result){
                                        $(".addCartButton").html("已加入购物车");
                                        $(".addCartButton").attr("disabled","disabled");
                                        $(".addCartButton").css("background-color","lightgray")
                                        $(".addCartButton").css("border-color","lightgray")
                                        $(".addCartButton").css("color","black")
                                         
                                    }
                                   
                                }
                        );                          
                    }
                    else{
                     alert("请您先登录");
                    }
                   
                }
        );      
        return false;
    });
    $(".buyLink").click(function(){
        var page = "forecheckLogin";
        $.get(
                page,
                function(result){
                    if("success"==result){
                        var num = $(".productNumberSetting").val();
                        location.href= $(".buyLink").attr("href")+"&num="+num;
                    }
                    else{
                     alert("请您先登录");
                    }
                 
                }
        );      
        return false;
    });
     
    
     
    $("img.smallImage").mouseenter(function(){
        var bigImageURL = $(this).attr("bigImageURL");
        $("img.bigImg").attr("src",bigImageURL);
    });
     
    $("img.bigImg").load(
        function(){
            $("img.smallImage").each(function(){
                var bigImageURL = $(this).attr("bigImageURL");
                img = new Image();
                img.src = bigImageURL;
                 
                img.onload = function(){
                    $("div.img4load").append($(img));
                };
            });     
        }
    );
});
 
</script>
 
<div class="imgAndInfo">
 
    <div class="imgInimgAndInfo">
        <img src="img/productSingle/${p.firstProductImage.id}.jpg" class="bigImg">
        <div class="smallImageDiv">
            <c:forEach items="${p.productSingleImages}" var="pi">
                <img src="img/productSingle_small/${pi.id}.jpg" bigImageURL="img/productSingle/${pi.id}.jpg" class="smallImage">
            </c:forEach>
        </div>
        <div class="img4load hidden" ></div>
    </div>


    <div class="infoInimgAndInfo">
         
        <div class="productTitle">
            ${p.name}
        </div>
        <div class="productSubTitle">
            ${p.subTitle} 
        </div>



        <div class="productPrice">
           
            <div class="productPriceDiv">
              
                <div class="originalDiv">
                    <span class="originalPriceDesc">价格</span>
                    <span class="originalPriceYuan">¥</span>
                    <span class="originalPrice">
                        <fmt:formatNumber type="number" value="${p.originalPrice}" minFractionDigits="2"/>
                    </span>
                </div>

                <div class="promotionDiv">
                    <span class="promotionPriceDesc">促销价 </span>
                    <span class="promotionPriceYuan">¥</span>
                    <span class="promotionPrice">
                        <fmt:formatNumber type="number" value="${p.promotePrice}" minFractionDigits="2"/>
                    </span>
                </div>
            </div>
        </div>

        <div class="productNumber">
            <span>数量</span>
            <span>
                <span class="productNumberSettingSpan">
                <input class="productNumberSetting" type="text" value="1">
                </span>
                <span class="arrow">
                    <a href="#nowhere" class="increaseNumber">
                    <span class="updown">
                            <img src="img/site/increase.png">
                    </span>
                    </a>
                     
                    <span class="updownMiddle"> </span>
                    <a href="#nowhere"  class="decreaseNumber">
                    <span class="updown">
                            <img src="img/site/decrease.png">
                    </span>
                    </a>
                     
                </span>
                     
            件</span>
            <span>库存${p.stock}件</span>
        </div>
      
         
        <div class="buyDiv">
            <a class="buyLink" href="forebuyone?pid=${p.id}"><button class="buyButton">立即购买</button></a>
        </div>
    </div>
     
    <div style="clear:both"></div>
     
</div>