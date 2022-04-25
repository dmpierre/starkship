%builtins output pedersen range_check

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_nn,
    assert_nn_le,
    sign
)



func main {output_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr:felt} ():
    # user inputs a list of coordinates along with a sentence input (?)
    # each coordinate gets hashed along with the sentence input
    # output is a list of hash values
    alloc_locals 
    local shot_location:felt
    local ship_location:felt
    local shifter:felt

    %{ 
    ids.shot_location = program_input["shot_location"]
    ids.ship_location = program_input["ship_location"]
    ids.shifter = program_input["shifter"]
    %}

    with_attr error_message("revelear: shot location must be between 0 and 63"):
        assert_nn_le(shot_location, 63)
    end 

    with_attr error_message("revelear: shifter must not be null"):
        assert_not_zero(shifter)
    end 
    
    let hash_shifter: felt = hash2 {hash_ptr=pedersen_ptr} (shifter, 0)
    let hash_shot_location: felt= hash2 {hash_ptr=pedersen_ptr} (shot_location, shifter)
    let hash_ship_location: felt= hash2 {hash_ptr=pedersen_ptr} (ship_location, shifter)

    local is_ship : felt

    if hash_shot_location == hash_ship_location:
        is_ship = 1
    else:
        is_ship = 0
    end
    let sign_hash: felt = sign(hash_shifter)
    if  sign_hash == -1:    
        hash_shifter = hash_shifter * (-1)
    end

    serialize_word(hash_shifter)
    serialize_word(hash_ship_location)
    serialize_word(is_ship)
    serialize_word(shot_location)
    return()
end