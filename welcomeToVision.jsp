<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="java.math.*" %>

<jsp:useBean id="db" class="com.db" scope="request">
	<jsp:setProperty name="db" property="*"/>
</jsp:useBean>

<html>
	<head>
		<!-- Timer for splash screen -->
		<META HTTP-EQUIV="Refresh" CONTENT="3" URL="">
		<title>Vision</title>
		<link rel="stylesheet" type="text/css" href="Styles.css" />
	</head>

		<!-- Splash image -->
		<center>
			<img src="images/Splash.png"/>
		</center>
		
		<!-- Version Information -->
		<div class=load>
			</br>
			Version: 1.1 
			</br>
			Database Version: 1.4
			</br>
	
	<%  //Startup tasks
		if (session.getAttribute ("run") == null)
		{
			boolean run = true;
			session.setAttribute ("run", run);
	%>
			Initialising shopping basket </br>
	<%
			Vector shoppingBasketInit = new Vector();
			session.setAttribute("shoppingBasket", shoppingBasketInit);
	%>
			Retrieving next transaction number </br>
	<%
			int transactionID = db.getNextTransID();
	%>		
			Next transaction number is... <% out.print(transactionID); %> </br>
	</div>
	<%
			session.setAttribute("transactionID", transactionID);
		}
		//Redirect
		else
		{
			session.removeAttribute("run");			
			response.sendRedirect("shoppingBasket.jsp");
		}
	%>
	</body>
</html>
