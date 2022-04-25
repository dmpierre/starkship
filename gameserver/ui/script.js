'use strict';

const shipLocationInput = document.getElementById("ship-location")
const shifterValueInput = document.getElementById("shifter-value")
const btnGetProperties = document.getElementById("btn-get-properties")

const maskerPgHash = document.getElementById("masker-pg-hash")
const revealerPgHash = document.getElementById("revealer-pg-hash")

const locationHash = document.getElementById("location-hash")
const shifterHash = document.getElementById("shifter-hash")
const isShip = document.getElementById("is-ship")

async function getMaskerPgHash () {
    const response = await fetch('http://localhost:5000/masker_program_hash')
    const data = await response.json()
    maskerPgHash.innerText = "Pg hash: " + data.clean_stdout
    console.log(data)
    return data
}

async function getRevealerPgHash () {
    const response = await fetch('http://localhost:5000/revealer_program_hash')
    const data = await response.json()
    revealerPgHash.innerText = "Pg hash: " + data.clean_stdout
    console.log(data)
    return data
}

window.addEventListener('load', () => {
    let _ = getMaskerPgHash();
    _ = getRevealerPgHash();
})

async function getRevealerValues () {
    const shipLocation = document.getElementById("ship-location").value
    const shotLocation = document.getElementById("shot-location").value
    const shifterValue = shifterValueInput.value
    const requestUrl = `http://localhost:5000/reveal?shifter=${shifterValue}&ship-location=${shipLocation}&shot-location=${shotLocation}`
    const response = await fetch(requestUrl)
    const data = await response.json()
    console.log(data)
    shifterHash.innerText = "Shifter hash: " +  data.clean[0]
    locationHash.innerText = "Location hash: "  + data.clean[1]
    isShip.innerText = "Is ship: " + data.clean[2]

}

btnGetProperties.addEventListener('click', () => {
    getRevealerValues();
})