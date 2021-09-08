package com.sixnicorn.eateryzip.filter;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//로그인 필터는 회원의 경우에만 적용
@WebFilter(urlPatterns = {"/eatery/private/*"}) 
public class LoginIFilter implements Filter {

	@Override
	public void destroy() {
	
	}
	//필터가 동작 될 때 호출되는 메소드 
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
			//1. 로그인을 했는지 로그인 된 일반회원 아이디를 읽어와본다. 
		     HttpServletRequest req=(HttpServletRequest)request;
		     HttpSession session=req.getSession();
		    
		    String g_id = (String)session.getAttribute("g_id");
		    if(g_id != null) {
				//2. 만일 로그인 을 했다면 관여 하지 않고 요청의 흐름을 이어간다. ( FilterChain 객체)
			    chain.doFilter(request, response);
		    }else {
		         /*
		          *  로그인 페이지로 강제 리다일렉트 됬다면 
		          *  로그인 성공후에 원래 가려던 목적지로 다시 보내야 하고
		          *  GET 방식 전송 파라미터가 있다면 파라미터 정보도 같이 가지고 갈수 있도록 해야한다.
		          */
		         //원래 가려던 url 정보 읽어오기
		         String url=req.getRequestURI();
		         //GET 방식 전송 파라미터를 query 문자열로 읽어오기 ( a=xxx&b=xxx&c=xxx )
		         String query=req.getQueryString();
		         //특수 문자는 인코딩을 해야한다.
		         String encodedUrl=null;
		         if(query==null) {//전송 파라미터가 없다면 
		            encodedUrl=URLEncoder.encode(url); //java.net 패키것을 import 
		         }else {
		            // 원래 목적지가 /test/xxx.jsp 라고 가정하면 아래와 같은 형식의 문자열을 만든다.
		            // "/test/xxx.jsp?a=xxx&b=xxx ..."
		            encodedUrl=URLEncoder.encode(url+"?"+query);
		         }
		    	
			    //3. 로그인을 하지 않았다면 /users/loginform.do 페이지로 리다일렉트 이동시킨다. (HttpServletResponse 객체)
			    HttpServletResponse resp =(HttpServletResponse)response;
				String cPath = req.getContextPath();
				resp.sendRedirect(cPath+"/users/g_login_form.do?url="+encodedUrl); 
		    }
		    
		    
	}

	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
			
	}

}
