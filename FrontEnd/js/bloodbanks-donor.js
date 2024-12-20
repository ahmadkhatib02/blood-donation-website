const redCross= document.getElementById("selection1")
const hospital= document.getElementById("selection2")
const buttons = document.querySelector(".buttons")
const contact = document.getElementsByClassName("Contact")
const name = document.getElementsByClassName("name")
const adress = document.getElementsByClassName("adress")
const main = document.getElementById("main")
let booking = new Object();
let allLocations = {}


//fetching the id 
function getRecipientIDFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get("recipient_id");
}

const recipientID = getRecipientIDFromURL();

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
                <h1 class="name">${element[i].branch_name}</h1>
                <a class="Contact"> Contact Now</a>
            </div>
            <p class="adress">${element[i].street}</p>
            <p>Contact Number: ${element[i].phone}</p>  
        </div>
            
    </section>
`
    }

    for(let i=0; i<contact.length; i++){
        let message= `Thank you for contacting ${element[i].branch_name}!
                      You can visit the organization whenever you want.`
        
        contact[i].addEventListener("click", async function(){
            window.alert(message) 

            try{
                const branchID = element[i].id
                const response = await fetch("http://127.0.0.1:5000/update_recipient", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ branch_ID: branchID, recipient_ID: recipientID }) 
                })
                if (response.ok) {
                    const data = await response.json();
                    console.log("Recipient updated successfully:", data);
                    window.location.href = "homePage.html";
                } else {
                    console.error("Failed to update recipient:", response.statusText);
                    window.alert("Failed to update recipient. Please try again.");
                }
            } 
            catch (error) {
                console.error("Error in updating recipient:", error);
                window.alert("An error occurred while contacting the organization.");
            }
            }
        )
    }
}