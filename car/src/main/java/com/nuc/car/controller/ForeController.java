package com.nuc.car.controller;

import com.github.pagehelper.PageHelper;
import com.nuc.car.pojo.*;
import com.nuc.car.service.*;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpSession;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("")
public class ForeController {
    @Autowired
    CategoryService categoryService;
    @Autowired
    ProductService productService;
    @Autowired
    UserService userService;
    @Autowired
    ProductImageService productImageService;
    @Autowired
    PropertyValueService propertyValueService;
    @Autowired
    OrderService orderService;
    @Autowired
    OrderItemService orderItemService;

    @RequestMapping("forehome")
    public String home(Model model) {
        List<Category> cs= categoryService.list();
        productService.fill(cs);
        productService.fillByRow(cs);
         model.addAttribute("cs", cs);
        return "fore/home";
    }

    @RequestMapping("foreregister")
    public String register(Model model,User user) {
        String name =  user.getName();
        name = HtmlUtils.htmlEscape(name);
        user.setName(name);
        boolean exist = userService.isExist(name);
        
        if(exist){
            String m ="用户名已经被使用,不能使用";
            model.addAttribute("msg", m);


            return "fore/register";
        }
        userService.add(user);

        return "redirect:registerSuccessPage";
    }
    
    
    @RequestMapping("forelogin")
    public String login(@RequestParam("name") String name, @RequestParam("password") String password, Model model, HttpSession session) {
        name = HtmlUtils.htmlEscape(name);
        User user = userService.get(name,password);

        if(null==user){
            model.addAttribute("msg", "账号密码错误");
            return "fore/login";
        }
        session.setAttribute("user", user);
        return "redirect:forehome";
    }
    @RequestMapping("forelogout")
    public String logout( HttpSession session) {
        session.removeAttribute("user");
        return "redirect:forehome";
    }

    @RequestMapping("foreproduct")
    public String product( int pid, Model model) {
        Product p = productService.get(pid);

        List<ProductImage> productSingleImages = productImageService.list(p.getId(), ProductImageService.type_single);
        List<ProductImage> productDetailImages = productImageService.list(p.getId(), ProductImageService.type_detail);
        p.setProductSingleImages(productSingleImages);
        p.setProductDetailImages(productDetailImages);

        List<PropertyValue> pvs = propertyValueService.list(p.getId());
     
        model.addAttribute("p", p);
        model.addAttribute("pvs", pvs);
        return "fore/product";
    }

    @RequestMapping("forecategory")
    public String category(int cid,String sort, Model model) {
        Category c = categoryService.get(cid);
        productService.fill(c);
        model.addAttribute("c", c);
        return "fore/category";
    }

    @RequestMapping("foresearch")
    public String search( String keyword,Model model){

        PageHelper.offsetPage(0,20);
        List<Product> ps= productService.search(keyword);
      
        model.addAttribute("ps",ps);
        return "fore/searchResult";
    }
    @RequestMapping("forebuyone")
    public String buyone(int pid, int num, HttpSession session) {
        Product p = productService.get(pid);
        int oiid = 0;

        User user =(User)  session.getAttribute("user");
        boolean found = false;
        List<OrderItem> ois = orderItemService.listByUser(user.getId());
     
        OrderItem oi = new OrderItem();
        oi.setUid(user.getId());
        oi.setNumber(num);
        oi.setPid(pid);
        orderItemService.add(oi);
        oiid = oi.getId();
        
        return "redirect:forebuy?oiid="+oiid;
    }

    @RequestMapping("forebuy")
    public String buy( Model model,String[] oiid,HttpSession session){
        List<OrderItem> ois = new ArrayList<>();
        float total = 0;

        for (String strid : oiid) {
            int id = Integer.parseInt(strid);
            OrderItem oi= orderItemService.get(id);
            total +=oi.getProduct().getPromotePrice()*oi.getNumber();
            ois.add(oi);
        }

        session.setAttribute("ois", ois);
        model.addAttribute("total", total);
        return "fore/buy";
    }

    

    @RequestMapping("forecreateOrder")
    public String createOrder( Model model,Order order,HttpSession session){
        User user =(User)  session.getAttribute("user");
        String orderCode = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()) + RandomUtils.nextInt(10000);
        order.setOrderCode(orderCode);
        order.setCreateDate(new Date());
        order.setUid(user.getId());
        order.setStatus(OrderService.waitPay);
        List<OrderItem> ois= (List<OrderItem>)  session.getAttribute("ois");

        float total =orderService.add(order,ois);
        return "redirect:forepayed?oid="+order.getId() +"&total="+total;
    }


    @RequestMapping("forepayed")
    public String payed(int oid, float total, Model model) {
        Order order = orderService.get(oid);
        order.setStatus(OrderService.waitDelivery);
        order.setPayDate(new Date());
        orderService.update(order);
        model.addAttribute("o", order);
        return "fore/payed";
    }

    @RequestMapping("forebought")
    public String bought( Model model,HttpSession session) {
        User user =(User)  session.getAttribute("user");
        List<Order> os= orderService.list(user.getId(),OrderService.delete);

        orderItemService.fill(os);

        model.addAttribute("os", os);

        return "fore/bought";
    }

    @RequestMapping("foreconfirmPay")
    public String confirmPay( Model model,int oid) {
        Order o = orderService.get(oid);
        orderItemService.fill(o);
        model.addAttribute("o", o);
        return "fore/confirmPay";
    }
    @RequestMapping("foreorderConfirmed")
    public String orderConfirmed( Model model,int oid) {
        Order o = orderService.get(oid);
        o.setStatus(OrderService.finish);
        o.setConfirmDate(new Date());
        orderService.update(o);
        return "fore/orderConfirmed";
    }
    @RequestMapping("foredeleteOrder")
    @ResponseBody
    public String deleteOrder( Model model,int oid){
        Order o = orderService.get(oid);
        o.setStatus(OrderService.delete);
        orderService.update(o);
        return "success";
    }
    
    
  
  @RequestMapping("forecheckLogin")
  @ResponseBody
  public String checkLogin( HttpSession session) {
      User user =(User)  session.getAttribute("user");
      if(null!=user)
          return "success";
      return "fail";
  }


}

