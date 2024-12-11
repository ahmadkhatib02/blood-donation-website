const redCross= document.getElementById("selection1")
const hospital= document.getElementById("selection2")
const buttons = document.querySelector(".buttons")
const contact = document.getElementsByClassName("Contact")
const name = document.getElementsByClassName("name")
const adress = document.getElementsByClassName("adress")
const main = document.getElementById("main")
let booking = new Object();
let allLocations = {}


//fetching the city
async function getRecipientInfo(recipientId) {
    const url = `http://localhost:5000/recipient/${recipientId}`; // Replace with your backend URL
    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                // Add Authorization header if required
                // 'Authorization': 'Bearer YOUR_TOKEN_HERE'
            },
        });

        if (!response.ok) {
            throw new Error(`Error: ${response.status} - ${response.statusText}`);
        }

        const data = await response.json();
        console.log(data);
        // Do something with the data (e.g., display it on the UI)
        return data.recipient;
    } catch (error) {
        console.error('Error fetching recipient info:', error);
    }
}

// Example usage
getRecipientInfo(1).then((recipient) => {
    if (recipient) {
        console.log(`Recipient Name: ${recipient.firstName} ${recipient.lastName}`);
    } else {
        console.log('Recipient not found.');
    }
});

//fetching all the data
async function fetchLocations() {
    
    try {
        // Fetch hospitals (type=H)
        const hospitalsResponse = await fetch("http://127.0.0.1:5000/locations?type=H")
        const hospitalsData = await hospitalsResponse.json()
        allLocations.hospitals = hospitalsData.locations

        // Fetch Red Cross branches (type=R)
        const redCrossResponse = await fetch("http://127.0.0.1:5000/locations?type=R")
        const redCrossData = await redCrossResponse.json()
        allLocations.redCross = redCrossData.locations

        //default page
        displayElements(allLocations.hospitals)

        
    } catch (error) {
        console.error("Error fetching locations:", error)
    }

    return allLocations 
}
    fetchLocations()

    

redCross.addEventListener("click",function(){
    console.log("clicked")
    //styling
    redCross.style.backgroundColor="black"
    redCross.style.borderRadius="30px"
    redCross.style.color="white"
    redCross.style.padding="13px 23px"
    
    hospital.style.backgroundColor="white"
    hospital.style.borderRadius="0px"
    hospital.style.color="black"
    hospital.style.padding="0px"

    buttons.style.padding="10px 26px 10px 0px"

    //adding the content
    displayElements(allLocations.redCross)

})

hospital.addEventListener("click",function(){
    console.log("clicked")
    //styling
    hospital.style.backgroundColor="black"
    hospital.style.borderRadius="30px"
    hospital.style.color="white"
    hospital.style.padding="13px 23px"
    
    redCross.style.backgroundColor="white"
    redCross.style.borderRadius="0px"
    redCross.style.color="black"
    redCross.style.padding="0px"

    buttons.style.padding="10px 0px 10px 26px"

    //adding the content
    displayElements(allLocations.hospitals)
})

function displayElements(element){
    for (let j=0; j<element.length;j++){

    }
    main.innerHTML=""
    for(let i=0;i<element.length;i++){
        main.innerHTML += `  
        <section>
        <div class="bloodbank">
            <div class="bank-header">
                <h1 class="name">${element[i].name}</h1>
                <a class="Contact"> Contact Now</a>
            </div>
            <p class="adress">${element[i].street}</p>
            <p>Contact Number: ${element[i].phone}</p>  
        </div>
            
    </section>
`
    }

    for(let i=0; i<contact.length; i++){
        contact[i].addEventListener("click",function(){
            book(booking,name[i].innerText, adress[i].innerText)  
        })
    }
}

 async function book (booking, name, adress){
    booking["name"]= name
    booking["adress"]= adress
    try {
        // Send the booking data to the backend
        const response = await fetch("http://127.0.0.1:5000/donors", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(booking), // Convert booking object to JSON
        });

        if (response.ok) {
            const responseData = await response.json();
            console.log("Order stored successfully:", responseData);

            // Optionally navigate to another page
            window.location.href = "profile-recipient.html";
        } else {
            console.error("Failed to store order:", response.statusText);
        }
    } catch (error) {
        console.error("Error in booking process:", error);
    }
}