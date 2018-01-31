<html>

	<head>
		<!-- Web page title -->
    	<title>Top Trumps</title>
  
    	
    	<!-- Import JQuery, as it provides functions you will probably find useful (see https://jquery.com/) -->
    	<script src="https://code.jquery.com/jquery-2.1.1.js"></script>
    	<script src="https://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
    	<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.1/themes/flick/jquery-ui.css">

		<meta charset="utf-8">
  		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  
		<!-- Optional Styling of the Website, for the demo I used Bootstrap (see https://getbootstrap.com/docs/4.0/getting-started/introduction/) -->

		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


    <body onload="initalize()"> <!-- Call the initalize method when the page loads -->

	<style>
    /* Remove the navbar's default margin-bottom and rounded borders */ 
    .navbar {
      margin-bottom: 0;
      border-radius: 0;
    }
    
    /* Set height of the grid so .sidenav can be 100% (adjust as needed) */
    .row.content {height: 100%}
    
    /* Set gray background color and 100% height */
    .sidenav {
      padding-top: 20px;
      background-color: #f1f1f1;
      height: 100%;
    }
    
    
    /* Set black background color, white text and some padding */
    footer {
      background-color: #555;
      color: white;
      padding: 15px;
    }
    
    /* On small screens, set height to 'auto' for sidenav and grid */
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        padding: 15px;
      }
      .row.content {height:auto;} 
    }
  </style>
</head>
<body>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Top Trumps</a>
    </div>
      <ul class="nav navbar-nav">
        <li class="active"><a href="/game/">Game</a></li>
        <li><a href="/toptrumps/">Home</a></li>
        <li><a href="/stats/">Stats</a></li>
      </ul>
  </div>
</nav>
  
<div class="container-fluid text-center">    
  <div class="row content">
  <div class="col-sm-2 sidenav">
  </div>
 
  
    <div class="col-sm-8 text-center"> 
      <h1>Top Trumps!</h1>
      <p>Choose the amount of players you'd like to play against:</p>
     <input type="number" id="input1" min="1" max="5"/>
			<button onclick="chooseNumberPlayers()" width="25">Submit</button>
      <hr>
      <h3>Let's Play!</h3>
      <p>Choose your top category...</p>
      
      <div class="panel-group" style="height: 500px; width:250px">
  		    <div class="panel panel-success">
      			<div class="panel-heading">Human Player</div>
      			<div class="panel-body">CARD INFO</div>
    		</div>
  		<div class="panel panel-default">
      			<div class="panel-heading">AI Player</div>
      			<div class="panel-body">CARD INFO</div>
    		</div>
    		<div class="panel panel-default">
      			<div class="panel-heading">AI Player</div>
      			<div class="panel-body">CARD INFO</div>
    		</div>
    		<div class="panel panel-default">
      			<div class="panel-heading">AI Player</div>
      			<div class="panel-body">CARD INFO</div>
    		</div>
    		<div class="panel panel-default">
      			<div class="panel-heading">AI Player</div>
      			<div class="panel-body">CARD INFO</div>
    		</div>
    	
	</div>
 
    </div>
    
    
    
    
    
    
     <div class="col-sm-2 sidenav">
  	</div>
</div>
</div>

	<footer class="container-fluid text-center">
  		<p>Created by the Nerd Patrol</p>
	</footer>
		</body>
	

	<script type="text/javascript">
		
			// Method that is called on page load
			function initalize() {
			
				// --------------------------------------------------------------------------
				// You can call other methods you want to run when the page first loads here
				// --------------------------------------------------------------------------
				
				// For example, lets call our sample methods
				helloJSONList();
				helloWord("Student");

				chooseNumberPlayers();
				displayCard();
				

				cardTest();

			}
			
			// -----------------------------------------
			// Add your other Javascript methods Here
			// -----------------------------------------
		
			// This is a reusable method for creating a CORS request. Do not edit this.
			function createCORSRequest(method, url) {
  				var xhr = new XMLHttpRequest();
  				if ("withCredentials" in xhr) {

    				// Check if the XMLHttpRequest object has a "withCredentials" property.
    				// "withCredentials" only exists on XMLHTTPRequest2 objects.
    				xhr.open(method, url, true);

  				} else if (typeof XDomainRequest != "undefined") {

    				// Otherwise, check if XDomainRequest.
    				// XDomainRequest only exists in IE, and is IE's way of making CORS requests.
    				xhr = new XDomainRequest();
    				xhr.open(method, url);

 				 } else {

    				// Otherwise, CORS is not supported by the browser.
    				xhr = null;

  				 }
  				 return xhr;
			}
		
		</script>
		
		<!-- Here are examples of how to call REST API Methods -->
		<script type="text/javascript">
		
			function displayCard(){
				for (var i=0; i<5; i++)	{
					document.write( <td bgcolor="#00CCFF" valign="top" align="center" width="200"
						height="300"><b>Player 1</b></td> )
				}
			
			}
		
			function chooseNumberPlayers(){
    			var number=document.getElementById('input1').value;
    			var xhr = createCORSRequest('GET', "http://localhost:7777/toptrumps/setPlayers?Number="+number); // Request type and URL+parameters
    			if (!xhr) {
  					alert("CORS not supported");
				}
		
				xhr.send();	
				
 			}
		
			// This calls the helloJSONList REST method from TopTrumpsRESTAPI
			function helloJSONList() {
			
				// First create a CORS request, this is the message we are going to send (a get request in this case)
				var xhr = createCORSRequest('GET', "http://localhost:7777/toptrumps/helloJSONList"); // Request type and URL
				
				// Message is not sent yet, but we can check that the browser supports CORS
				if (!xhr) {
  					alert("CORS not supported");
				}

				// CORS requests are Asynchronous, i.e. we do not wait for a response, instead we define an action
				// to do when the response arrives 
				xhr.onload = function(e) {
 					var responseText = xhr.response; // the text of the response
					alert(responseText); // lets produce an alert
				};
				
				// We have done everything we need to prepare the CORS request, so send it
				xhr.send();		
			}
			
			// This calls the helloJSONList REST method from TopTrumpsRESTAPI
			function helloWord(word) {
			
				// First create a CORS request, this is the message we are going to send (a get request in this case)
				var xhr = createCORSRequest('GET', "http://localhost:7777/toptrumps/helloWord?Word="+word); // Request type and URL+parameters
				
				// Message is not sent yet, but we can check that the browser supports CORS
				if (!xhr) {
  					alert("CORS not supported");
				}

				// CORS requests are Asynchronous, i.e. we do not wait for a response, instead we define an action
				// to do when the response arrives 
				xhr.onload = function(e) {
 					var responseText = xhr.response; // the text of the response
					alert(responseText); // lets produce an alert
				};
				
				// We have done everything we need to prepare the CORS request, so send it
				xhr.send();		
			}
			
			function cardTest() {
			
				var xhr = createCORSRequest('GET', "http://localhost:7777/toptrumps/cardTest");
				
				if (!xhr) {
  					alert("Fucked it");
				}
				xhr.onload = function(e) {
 					var responseText = xhr.response; // the text of the response
 					var rT = JSON.parse(responseText);
					document.getElementById("name").innerHTML = rT["name"];
					for (i = 0; i < rT.number_OF_CATEGORIES; i++){
						document.getElementById(("cat" + (i+1))).innerHTML = rT["categories"][i];
						document.getElementById(("val" + (i+1))).innerHTML = rT["cardValues"][i];
					}
					
					alert(rT.name);
				};
				
				xhr.send();
				
			
			}
			
			
			
			

		</script>
		
		
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
		
	
		</body>
</html>