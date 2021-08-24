<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일반회원 로그인</title>
</head>
<body>
<div class="container">
   <h1>로그인 폼 입니다.</h1>
   <form action="${pageContext.request.contextPath}/users/g_login.do" method="post">
      <c:choose>
         <c:when test="${ empty param.url }">
            <input type="hidden" name="url" value="${pageContext.request.contextPath}/"/>
         </c:when>
         <c:otherwise>
            <input type="hidden" name="url" value="${param.url }"/>
         </c:otherwise>
      </c:choose>
      <div>
         <label for="g_id">아이디</label>
         <input type="text" name="g_id" id="g_id"/>
      </div>
      <div>
         <label for="g_pwd">비밀번호</label>
         <input type="password" name="g_pwd" id="g_pwd"/>
      </div>
      <button type="submit">로그인</button>
      <a href="${pageContext.request.contextPath}/users/b_login_form.do">비즈니스회원 로그인으로 이동</a>	
   </form>
</div>
</body>
</html>