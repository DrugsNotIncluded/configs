#!/bin/bash

transparency_val=$1

function GetFocusedID()
{
    local focused=""
    local ids=($(swaymsg -t get_tree | grep -oP  '"id"\s*:\s*\K[^,]+'))
    local is_focused=($(swaymsg -t get_tree | grep -oP  '"focused"\s*:\s*\K[^,]+'))
    declare -i counter=0
    for state in "${is_focused[@]}"
    do
        counter+=1
        if [ $state = "true" ]; then
            focused="${ids[$counter]}"
        fi
    done

    echo $focused
}

function SetOpacity()
{
    swaymsg "[con_id=$1]" opacity $2
}

focused_id=$(GetFocusedID)
old_focus=$focused_id
ids=($(swaymsg -t get_tree | grep -oP  '"id"\s*:\s*\K[^,]+'))
for id in "${ids[@]}"
do
    if ! [[ $id = $focused_id ]]; then
        #echo $id $focused_id
	SetOpacity $id $transparency_val
    fi
done



swaymsg -rt subscribe -m '[ "window" ]' | while read
do
    change=$(echo $REPLY | grep  -oP  '"change"\s*:\s*"\K[^"]+')
    id=$(echo $REPLY | grep  -oP '"id"\s*:\s*\K[^,]+')

    if [[ ($change = focus) ]] ; then
        SetOpacity $old_focus $transparency_val
        SetOpacity $id '1.0'
        old_focus=$id
    fi
done

