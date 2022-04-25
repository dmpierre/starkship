'use strict';

const shipLocationInput = document.getElementById("ship-location")
const shifterValueInput = document.getElementById("shifter-value")
const btnGetProperties = document.getElementById("btn-get-properties")

const maskerPgHash = document.getElementById("masker-pg-hash")
const revealerPgHash = document.getElementById("revealer-pg-hash")

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