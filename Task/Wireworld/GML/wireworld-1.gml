//Create event
/*
Wireworld first declares constants and then reads a wireworld from a textfile.
In order to implement wireworld in GML a single array is used.
To make it behave properly, there need to be states that are 'in-between' two states:
0 = empty
1 = conductor from previous state
2 = electronhead from previous state
5 = electronhead that was a conductor in the previous state
3 = electrontail from previous state
4 = electrontail that was a head in the previous state
*/
empty = 0;
conduc = 1;
eHead = 2;
eTail = 3;
eHead_to_eTail = 4;
coduc_to_eHead = 5;
working = true;//not currently used, but setting it to false stops wireworld. (can be used to pause)
toroidalMode = false;
factor = 3;//this is used for the display. 3 means a single pixel is multiplied by three in size.

var tempx,tempy ,fileid, tempstring, gridid, listid, maxwidth, stringlength;
tempx = 0;
tempy = 0;
tempstring = "";
maxwidth = 0;

//the next piece of code loads the textfile containing a wireworld.
//the program will not work correctly if there is no textfile.
if file_exists("WW.txt")
{
fileid = file_text_open_read("WW.txt");
gridid = ds_grid_create(0,0);
listid = ds_list_create();
    while !file_text_eof(fileid)
    {
    tempstring = file_text_read_string(fileid);
    stringlength = string_length(tempstring);
    ds_list_add(listid,stringlength);
        if maxwidth < stringlength
        {
        ds_grid_resize(gridid,stringlength,ds_grid_height(gridid) + 1)
        maxwidth = stringlength
        }
        else
        {
        ds_grid_resize(gridid,maxwidth,ds_grid_height(gridid) + 1)
        }

        for (i = 1; i <= stringlength; i +=1)
        {
            switch (string_char_at(tempstring,i))
            {
            case ' ': ds_grid_set(gridid,tempx,tempy,empty); break;
            case '.': ds_grid_set(gridid,tempx,tempy,conduc); break;
            case 'H': ds_grid_set(gridid,tempx,tempy,eHead); break;
            case 't': ds_grid_set(gridid,tempx,tempy,eTail); break;
            default: break;
            }
        tempx += 1;
        }
    file_text_readln(fileid);
    tempy += 1;
    tempx = 0;
    }
file_text_close(fileid);
//fill the 'open' parts of the grid
tempy = 0;
    repeat(ds_list_size(listid))
    {
    tempx = ds_list_find_value(listid,tempy);
        repeat(maxwidth - tempx)
        {
        ds_grid_set(gridid,tempx,tempy,empty);
        tempx += 1;
        }
    tempy += 1;
    }
boardwidth = ds_grid_width(gridid);
boardheight = ds_grid_height(gridid);
//the contents of the grid are put in a array, because arrays are faster.
//the grid was needed because arrays cannot be resized properly.
tempx = 0;
tempy = 0;
    repeat(boardheight)
    {
        repeat(boardwidth)
        {
        board[tempx,tempy] = ds_grid_get(gridid,tempx,tempy);
        tempx += 1;
        }
    tempy += 1;
    tempx = 0;
    }
//the following code clears memory
ds_grid_destroy(gridid);
ds_list_destroy(listid);
}
