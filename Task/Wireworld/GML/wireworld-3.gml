//Draw event
/*
This event occurs whenever the screen is refreshed.
It checks everything on the board using an x and a y through two repeat loops and draws it.
It is an important step, because all board values are changed to the normal versions:
5 -> 2 (conductor changed to head)
4 -> 3 (head changed to tail)
*/
//draw sprites and text first

//now draw wireworld
var tempx,tempy;
tempx = 0;
tempy = 0;

repeat(boardheight)
{
    repeat(boardwidth)
    {
        switch board[tempx,tempy]
            {
            case empty:
            //draw_point_color(tempx,tempy,c_black);
            draw_set_color(c_black);
            draw_rectangle(tempx*factor,tempy*factor,(tempx+1)*factor-1,(tempy+1)*factor-1,false);
            break;
            case conduc:
            //draw_point_color(tempx,tempy,c_yellow);
            draw_set_color(c_yellow);
            draw_rectangle(tempx*factor,tempy*factor,(tempx+1)*factor-1,(tempy+1)*factor-1,false);
            break;
            case eHead:
            //draw_point_color(tempx,tempy,c_red);
            draw_set_color(c_blue);
            draw_rectangle(tempx*factor,tempy*factor,(tempx+1)*factor-1,(tempy+1)*factor-1,false);
            draw_rectangle_color(tempx*factor,tempy*factor,(tempx+1)*factor-1,(tempy+1)*factor-1,c_red,c_red,c_red,c_red,false);
            break;
            case eTail:
            //draw_point_color(tempx,tempy,c_blue);
            draw_set_color(c_red);
            draw_rectangle(tempx*factor,tempy*factor,(tempx+1)*factor-1,(tempy+1)*factor-1,false);
            break;
            case coduc_to_eHead:
            //draw_point_color(tempx,tempy,c_red);
            draw_set_color(c_blue);
            draw_rectangle(tempx*factor,tempy*factor,(tempx+1)*factor-1,(tempy+1)*factor-1,false);
            board[tempx,tempy] = eHead;
            break;
            case eHead_to_eTail:
            //draw_point_color(tempx,tempy,c_blue);
            draw_set_color(c_red);
            draw_rectangle(tempx*factor,tempy*factor,(tempx+1)*factor-1,(tempy+1)*factor-1,false);
            board[tempx,tempy] = eTail;
            break;
            default: break;
            }
    tempx += 1
    }
tempy += 1;
tempx = 0;
}
draw_set_color(c_black);
