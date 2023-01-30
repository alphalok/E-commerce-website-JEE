

<%@page import="cn.supermarche.model.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="cn.supermarche.connection.DbCon"%>
<%@page import="cn.supermarche.dao.ProduitDao"%>
<%@page import="cn.supermarche.model.Utilisateur"%>
<%Utilisateur auth=(Utilisateur)request.getSession().getAttribute("auth");
String id=request.getParameter("id");
String quantite=request.getParameter("quantite");
ArrayList<Panier> list_Panier = (ArrayList<Panier>) session.getAttribute("list-Panier");
double total =0;

if(auth!=null){
	request.setAttribute("auth",auth);
	
	List<Panier> panierproduit = null;
	if(list_Panier!=null){
		request.setAttribute("list_Panier",list_Panier);
	}
	
	if(id!=null && quantite!=null){

		request.setAttribute("id", Integer.parseInt(id));
		request.setAttribute("quantite", Integer.parseInt(quantite));
	}
	else if(!list_Panier.isEmpty()){
		
		ProduitDao pDao = new ProduitDao(DbCon.getConnection());
		panierproduit = pDao.getProduitsPanier(list_Panier);
		total = pDao.getPrixTotalPanier(list_Panier);
		request.setAttribute("list_Panier", list_Panier);
		request.setAttribute("total", total);
		
		
	}
	else{
		response.sendRedirect("index.jsp");
	}

	
	
	
}else{
	response.sendRedirect("login.jsp");
	
}




%>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Payment Checkout Form</title>
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.2/css/all.css">
	<link rel="stylesheet" href="paymentStyle.css">

</head>
<body>
	


<div class="wrapper">
  <div class="payment">
    <div class="payment-logo">
      <p>p</p>
    </div>
    
    
  
    
    <h2>Paiement par Cart</h2>
    
    <form class="form" method="GET" action="<% if(id!=null && quantite!=null){ %>acheter_maintenant<%}else if(!list_Panier.isEmpty()){%>finaliser-achat<%}%>">
      <div class="card space icon-relative">
        <label class="label">Nom du porteur de la carte:</label>
        <input type="text" class="input" placeholder="Nom du porteur de la carte" required>
        <i class="fas fa-user"></i>
      </div>
      <div class="card space icon-relative">
        <label class="label">Numero de la carte :</label>
        <input type="text" class="input" data-mask="0000 0000 0000 0000" placeholder="Numero de la carte" required="required">
        <i class="far fa-credit-card"></i>
      </div>
      <div class="card-grp space">
        <div class="card-item icon-relative">
          <label class="label">Date d'expiration:</label>
          <input type="text" name="expiry-data" class="input" data-mask="00 / 00"  placeholder="00 / 00" required="required">
          <i class="far fa-calendar-alt"></i>
        </div>
        <div class="card-item icon-relative">
          <label class="label">CVC:</label>
          <input type="text" class="input" data-mask="000" placeholder="000" r>
          <i class="fas fa-lock"></i>
        </div>
        
        <div style="display: none;">
        <%if(id!=null && quantite!=null){%>
        	
        	<input value="<%=id%>" name="id">
         	<input value="<%=quantite%>" name="quantite">
        	
        <% }else if(!list_Panier.isEmpty()){%>
        
        	<input value="<%=list_Panier%>" name="list_Panier">
         	<input value="<%=total%>" name="total">
        	
        	
       <%} %> 
        
        
          
        </div>
      </div>
     <button type="submit" class="btn" >Payer</button>
     </form>  
  </div>
</div>

	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.15/jquery.mask.min.js"></script>

</body>
</html>