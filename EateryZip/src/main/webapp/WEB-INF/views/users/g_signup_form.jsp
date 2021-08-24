<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.css" />
</head>
<body>
<div class="container">
   <h4>유효성 검사가 완전하지 않으니 우선 다 입력 부탁드려요</h4>
   <h1>회원 가입 폼 입니다.</h1>
   <!-- 절대 경로로 쓰면 확인하기가 쉽다. -->
   <form action="g_signup.do" method="post" id="myForm">
   	  <input type="hidden" name="grade" value="general" />
      <div>
         <label class="control-label" for="g_id">아이디</label>
         <input class="form-control" type="text" name="g_id" id="g_id"/>
         <small class="form-text text-muted">영문자 소문자로 시작하고 5글자~10글자 이내로 입력하세요.</small> <!-- 조금은 흐린 글씨로 나옴 -->
         <div class="invalid-feedback">사용 할 수 없는 아이디 입니다.</div>
      </div>
      <div>
         <label class="control-label" for="g_pwd">비밀번호</label>
         <input class="form-control" type="password" name="g_pwd" id="g_pwd"/>
         <small class="form-text text-muted" >5글자~10글자 이내로 입력하세요.</small>
         <div class="invalid-feedback">비밀번호를 확인 하세요.</div>
      </div>
      <div>
         <label class="control-label" for="g_pwd2">비밀번호 확인</label>
         <input class="form-control" type="password" name="g_pwd2" id="g_pwd2"/>
      </div>
      <div>
         <label class="control-label" for="g_name">이름</label>
         <input class="form-control" type="text" name="g_name" id="g_name"/>
      </div>
      <div>
         <label class="control-label" for="g_address">주소</label>
         <input class="form-control" type="text" name="g_address" id="g_address"/>
      </div>
      <div>
         <label class="control-label" for="g_email">이메일</label>
         <input class="form-control" type="text" name="g_email" id="g_email"/>
         <div class="invalid-feedback">이메일 형식을 확인 하세요.</div>
      </div> 
      <div>
         <label class="control-label" for="g_phone">연락처</label>
         <input class="form-control" type="text" name="g_phone" id="g_phone"/>
      </div>
      <button type="submit" class="btn btn-primary">가입</button>
   </form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/gura_util.js"></script>
<script>
   //아이디, 비밀번호, 이메일의 유효성 여부를 관리한 변수 만들고 초기값 대입
   let isIdValid=false;
   let isPwdValid=false;
   let isEmailValid=false;

   //아이디를 입력했을때(input) 실행할 함수 등록 
   document.querySelector("#id").addEventListener("input", function(){
      //일단 is-invalid is-valid 클래스를 제거한다.
      document.querySelector("#id").classList.remove("is-valid");
      document.querySelector("#id").classList.remove("is-invalid");
      
      //1. 입력한 아이디 value 값 읽어오기  
      let inputId=this.value;
      //입력한 아이디를 검증할 정규 표현식
      const reg_id=/^[a-z].{4,9}$/;
      //만일 입력한 아이디가 정규표현식과 매칭되지 않는다면
      if(!reg_id.test(inputId)){
         isIdValid=false; //아이디가 매칭되지 않는다고 표시하고 
         // is-invalid 클래스를 추가한다. 
         document.querySelector("#id").classList.add("is-invalid");
         return; //함수를 여기서 끝낸다 (ajax 전송 되지 않도록)
      }
      
      //2. util 에 있는 함수를 이용해서 ajax 요청하기
      ajaxPromise("${pageContext.request.contextPath}/users/checkid.do", "get", "inputId="+inputId)
      .then(function(response){
         return response.json();
      })
      .then(function(data){
         console.log(data);
         //data 는 {isExist:true} or {isExist:false} 형태의 object 이다.
         if(data.isExist){//만일 존재한다면
            //사용할수 없는 아이디라는 피드백을 보이게 한다. 
            isIdValid=false;
            // is-invalid 클래스를 추가한다. 
            document.querySelector("#id").classList.add("is-invalid");
         }else{
            isIdValid=true;
            document.querySelector("#id").classList.add("is-valid");
         }
      });
   });
   
   //비밀 번호를 확인 하는 함수 
   function checkPwd(){
	  document.querySelector("#pwd").classList.remove("is-valid");
	  document.querySelector("#pwd").classList.remove("is-invalid");
	   
      const pwd=document.querySelector("#pwd").value;
      const pwd2=document.querySelector("#pwd2").value;
      
      // 최소5글자 최대 10글자인지를 검증할 정규표현식
      const reg_pwd=/^.{5,10}$/;
      if(!reg_pwd.test(pwd)){
         isPwdValid=false;
         document.querySelector("#pwd").classList.add("is-invalid");
         return; //함수를 여기서 종료
      }
      
      if(pwd != pwd2){//비밀번호와 비밀번호 확인란이 다르면
         //비밀번호를 잘못 입력한것이다.
         //document.querySelector(".invalid-feedback2").style.display="block";
         isPwdValid=false;
         document.querySelector("#pwd").classList.add("is-invalid");
      }else{
         //document.querySelector(".invalid-feedback2").style.display="none";
         isPwdValid=true;
         document.querySelector("#pwd").classList.add("is-valid");
      }
   }
   
   //비밀번호 입력란에 input 이벤트가 일어 났을때 실행할 함수 등록
   document.querySelector("#pwd").addEventListener("input", checkPwd);
   document.querySelector("#pwd2").addEventListener("input", checkPwd);
   
   //이메일을 입력했을때 실행할 함수 등록
   document.querySelector("#email").addEventListener("input", function(){
	   document.querySelector("#email").classList.remove("is-valid");
	   document.querySelector("#email").classList.remove("is-invalid");
	   
      //1. 입력한 이메일을 읽어와서
      const inputEmail=this.value;
      //2. 이메일을 검증할 정규 표현식 객체를 만들어서
      const reg_email=/@/;
      //3. 정규표현식 매칭 여부에 따라 분기하기
      if(reg_email.test(inputEmail)){//만일 매칭된다면
         //document.querySelector(".invalid-feedback3").style.display="none";
         isEmailValid=true;
  	     document.querySelector("#email").classList.add("is-valid");
      }else{
         //document.querySelector(".invalid-feedback3").style.display="block";
         isEmailValid=false;
         document.querySelector("#email").classList.add("is-invalid");
      }
   });
   
   
   //폼에 submit 이벤트가 발생했을때 실행할 함수 등록
   document.querySelector("#myForm").addEventListener("submit", function(e){
      /*
         입력한 아이디, 비밀번호, 이메일의 유효성 여부를 확인해서 하나라도 유효 하지 않으면
         e.preventDefault(); 
         가 수행 되도록 해서 폼의 제출을 막아야 한다. 
      */
      //폼 전체의 유효성 여부 알아내기 
      let isFormValid = isIdValid && isPwdValid && isEmailValid;
      if(!isFormValid){//폼이 유효하지 않으면
         //폼 전송 막기 
         e.preventDefault();
      }   
   });
</script>
</body>
</html>




