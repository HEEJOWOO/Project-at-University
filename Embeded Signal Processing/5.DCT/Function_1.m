function Z=myfun_LoadImage(fname,row,col)
fin=fopen(fname,'r');
i=fread(fin,row*col,'uint8=>uint8');
Z=reshape(i,row,col);
Z=Z';