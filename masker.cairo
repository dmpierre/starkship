%builtins output pedersen range_check

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_nn,
    assert_nn_le,
)



func main {output_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt} ():
    # user inputs a list of coordinates along with a sentence input (?)
    # each coordinate gets hashed along with the sentence input
    # output is a list of hash values
    alloc_locals 
    local ship_location:felt
    local shifter:felt
    %{ 
    ids.ship_location = program_input["ship_location"]
    ids.shifter = program_input["shifter"]
    %}
    with_attr error_message("masker: boat location must be between 0 and 63"):
        assert_nn_le(ship_location, 63)
    end 

    with_attr error_message("masker: shifter must not be null"):
        assert_not_zero(shifter)
    end 
    
    let hash_shifter: felt = hash2 {hash_ptr=pedersen_ptr} (shifter, 0)
    let hash_ship_location: felt= hash2 {hash_ptr=pedersen_ptr} (ship_location, shifter)
    serialize_word(hash_shifter)
    serialize_word(hash_ship_location)
    
    return()
end