//Step event
/*
This step event executes each 1/speed seconds.
It checks everything on the board using an x and a y through two repeat loops.
The variables westN,northN,eastN,southN, resemble the space left, up, right and down respectively,
seen from the current x & y.
1 -> 5 (conductor is changing to head)
2 -> 4 (head is changing to tail)
3 -> 1 (tail became conductor)
*/

var tempx,tempy,assignhold,westN,northN,eastN,southN,neighbouringHeads,T;
tempx = 0;
tempy = 0;
westN = 0;
northN = 0;
eastN = 0;
southN = 0;
neighbouringHeads = 0;
T = 0;

if working = 1
{
    repeat(boardheight)
    {
        repeat(boardwidth)
        {
            switch board[tempx,tempy]
            {
            case empty: assignhold = empty; break;
            case conduc:
                neighbouringHeads = 0;
                if toroidalMode = true //this is disabled, but otherwise lets wireworld behave toroidal.
                {
                    if tempx=0
                    {
                    westN = boardwidth -1;
                    }
                    else
                    {
                    westN = tempx-1;
                    }
                    if tempy=0
                    {
                    northN = boardheight -1;
                    }
                    else
                    {
                    northN = tempy-1;
                    }
                    if tempx=boardwidth -1
                    {
                    eastN = 0;
                    }
                    else
                    {
                    eastN = tempx+1;
                    }
                    if tempy=boardheight -1
                    {
                    southN = 0;
                    }
                    else
                    {
                    southN = tempy+1;
                    }

                T=board[westN,northN];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                T=board[tempx,northN];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                T=board[eastN,northN];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                T=board[westN,tempy];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                T=board[eastN,tempy];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                T=board[westN,southN];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                T=board[tempx,southN];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                T=board[eastN,southN];
                    if T=eHead or T=eHead_to_eTail
                    {
                    neighbouringHeads += 1;
                    }
                }
                else//this is the default mode that works for the provided example.
                {//the next code checks whether coordinates fall outside the array borders.
                //and counts all the neighbouring electronheads.
                    if tempx=0
                    {
                    westN = -1;
                    }
                    else
                    {
                    westN = tempx - 1;
                    T=board[westN,tempy];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }
                    if tempy=0
                    {
                    northN = -1;
                    }
                    else
                    {
                    northN = tempy - 1;
                    T=board[tempx,northN];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }
                    if tempx = boardwidth -1
                    {
                    eastN = -1;
                    }
                    else
                    {
                    eastN = tempx + 1;
                    T=board[eastN,tempy];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }
                    if tempy = boardheight -1
                    {
                    southN = -1;
                    }
                    else
                    {
                    southN = tempy + 1;
                    T=board[tempx,southN];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }

                    if westN != -1 and northN != -1
                    {
                    T=board[westN,northN];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }
                    if eastN != -1 and northN != -1
                    {
                    T=board[eastN,northN];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }
                    if westN != -1 and southN != -1
                    {
                    T=board[westN,southN];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }
                    if eastN != -1 and southN != -1
                    {
                    T=board[eastN,southN];
                        if T=eHead or T=eHead_to_eTail
                        {
                        neighbouringHeads += 1;
                        }
                    }
                }
                    if neighbouringHeads = 1 or neighbouringHeads = 2
                    {
                    assignhold = coduc_to_eHead;
                    }
                    else
                    {
                    assignhold = conduc;
                    }
                break;

            case eHead: assignhold = eHead_to_eTail; break;
            case eTail: assignhold = conduc; break;
            default: break;
            }
        board[tempx,tempy] = assignhold;
        tempx += 1;
        }
    tempy += 1;
    tempx = 0;
    }
}
