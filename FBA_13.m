%����ʱ�ɽ�darktime�ĳɸ�С����(������8�ı���)��Լʱ�� 
%�䰵���1800-2000ms������500ms.�䰵ǰ200ms��˸����˸����100ms
%��ɫ�䰵32��
%���ڸ�ע�ӵ�
%min_seq= [1 2 3 3 4 5 6 6]
%1for�찵������2for�찵������3for�찵����
%4for�̰�������5for�̰�������6for�̰�����
%��¼sProbe(1for�찵������2for�찵������3for�찵����),tRTs(��Ӧʱ),tPress(����ʱ��)
%�޸ļ�������
%56��ϰ+112��ʽ+112��ʽ
%darktimePractice = 56;              
%darktime = 112; 
%�������ָ�Ϊ�Ĳ���

function FBA
Screen('Preference', 'SkipSyncTests', 1);
AssertOpenGL;

ID = input('The subject"s ID��', 's'); 
sex = input('Enter m for male & f for female:', 's');   %��¼����ID���Ա�
sSec=zeros(300,1);      %�ڼ����֣�0Ϊ��ϰ��1-2Ϊ��ʽ����
sPart=zeros(300,1);     %�䰵��ǣ�0-5
sProbe=zeros(300,1);    %��Ǻ�ɫ�䰵���������
tPress=zeros(300,1);    %��¼����ʱ��
tDark=zeros(300,1);     %��¼��ɫ�䰵ʱ��
tRTs =zeros(300,1);     %��¼��Ӧʱ
nPress=1;              %һ�α䰵�ڵڼ��ΰ���
nDark=2;               %�ڼ��κ�ɫ�䰵

try
    screens=Screen('Screens'); 
    screenNumber=max(screens);
    [w, rect] = Screen('OpenWindow', screenNumber, 0,[], 32, 2);
    
    mon_width   = 30;              % ��Ļ���(cm) 
    v_dist      = 50;              % ���۵���Ļ�ľ���(cm)
    ndots       = 50;              % ǰ��������
    ndots_right = 900;             % ����������
    ppd         = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;  % 1���ӽǵ����ظ���(pixels per degree )
    max_in      = 4;               % Բ������İ뾶(deg)
    min_in      = 0.25;            % minumum Բ����С����뾶
    rmax_in     = max_in * ppd;    % Բ������İ뾶(pixel)
    rmin_in     = min_in * ppd;     
    max_out     = 18;              % �������⾶
    min_out     = 5;               % �������ھ�
    rmax_out    = max_out * ppd;   % �������⾶
    rmin_out    = min_out * ppd;   % �������ھ�
    dot_w       = 0.2;             % ��Ŀ��(deg)
    s           = dot_w * ppd;     % ��Ŀ��(pixel)
    fix_r       = 0.15;            % ����ע�ӵ�Ŀ��(deg)
    [center(1), center(2)] = RectCenter(rect);              %����ע�ӵ������(pixel)
    centerLeft(1) = center(1);
    centerLeft(2) = center(2);
    centerRight(1) = center(1);
    centerRight(2) = center(2);
    fix_cord = [center-fix_r*ppd center+fix_r*ppd];         % ���ĵ�����
    KbName('UnifyKeyNames');
    responseKey = KbName('j');
    triggerKey = KbName('space');
    onExit = 'execution halted by experimenter';
    
    %ͼƬ��Ϣ
    picPre1 = 'pre1.jpg';
    picPre2 = 'pre2.jpg';
    picPra1 = 'pra1.jpg';
    picPra2 = 'pra2.jpg';
    picSec1 = 'sec1.jpg';
    picSec2 = 'sec2.jpg';
    picEnd1 = 'end1.jpg';
    picEnd2 = 'end2.jpg';
    picEnd3 = 'end3.jpg';
    picEnd4 = 'end4.jpg';
    picEnd = {picEnd1, picEnd2, picEnd3, picEnd4};
    
    %��ʼʱ��
    start = GetSecs;
    pressT = start;
 
    %��ʼ��Ļ����ֵ
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    fps=Screen('FrameRate',w);           %fps = frames per second
    ifi=Screen('GetFlipInterval', w);    %ifi = ��ʾ����ת���
    if fps==0
       fps=1/ifi;
    end;
    
    %��ľ���
    rRed1 = (rmax_in-rmin_in) * sqrt(rand(ndots,1))+rmin_in;     %Red1��ʾ����ĺ�ɫ�㼯 
    rGreen1 = (rmax_in-rmin_in) * sqrt(rand(ndots,1))+rmin_in;   %Green1��ʾ�������ɫ�㼯
    rRight = (rmax_out-rmin_out) * sqrt(rand(ndots_right,1))+rmin_out;    %Right��ʾ���ܵĵ㼯
 
    %��ĽǶ�
    tRed1 = 2*pi*rand(ndots,1);  
    csRed1 = [cos(tRed1), sin(tRed1)];
    tGreen1 = 2*pi*rand(ndots,1);                    
    csGreen1 = [cos(tGreen1), sin(tGreen1)];
    tRight = 2*pi*rand(ndots_right,1);                     
    csRight = [cos(tRight), sin(tRight)];
    
    %�������
    xyRed1 = [rRed1 rRed1] .* csRed1;   
    xyGreen1 = [rGreen1 rGreen1] .* csGreen1;
   
    %�����ɫ(RGBֵ)
    white = WhiteIndex(w);      %ע�ӵ���ɫ
    red1 = zeros(3,ndots);      %��ߺ�ɫ
    red1(1,:) = 255;
    colvectRed1 = uint8(round(red1));
    green1 = zeros(3,ndots);    %�����ɫ
    green1(2,:) = 128;
    colvectGreen1 = uint8(round(green1));
    red2 = zeros(3,ndots_right);      %�ұߺ�ɫ
    red2(1,:) = 255;
    colvectRed2 = uint8(round(red2));
    green2 = zeros(3,ndots_right);    %�ұ���ɫ
    green2(2,:) = 128;
    colvectGreen2 = uint8(round(green2));
    black = zeros(3,ndots_right);    %�ұߺ�ɫ
    colvectBlack = uint8(round(black));
    color = 1;                  %�ж���ߵ���ɫ��1Ϊ��ɫ��2Ϊ��ɫ

    %ʱ���������
    SOA = 2;                           %�ұ���˸������߱䰵��ʱ����
    timeColorDark = 5;                 %��ߵ�䰵ʱ�䳤��
    countColorDarkRed1 = 1;            %��ߺ�ɫ��䰵ʱ�䳤�ȼ���
    countColorDarkGreen1 = 1;          %�����ɫ��䰵ʱ�䳤�ȼ���
    darktimePractice = 8;              %��ϰһ����䰵�Ĵ���
    darktime = 8;                     %��ʽʵ���һ��sec��䰵�Ĵ���
    endtime1 = 2;
    endtime2 = 2;
    
    HideCursor;                          %�������
    Priority(MaxPriority(w));            %������Ļ���ȼ�
    
    for j = 1:4
        countFrame = 1;                    %ÿ�α䰵��ڼ���100ms
        countDark = 1;                     %�ڼ��α䰵
        ifDark = 0;                        %�жϵ��Ƿ�䰵   
        ifFlash = 0;                       %�ұ��Ƿ���˸

        %���������ʱ����   
        darkInterval = zeros(1,darktimePractice);  
        for i = 1:darktimePractice
            darkInterval(i) = unidrnd(3)+17;
        end
        %����α�����
        min_seq= [1 2 3 3 4 5 6 6];
        seq_order = zeros(darktimePractice,1);  %1for�찵������2for�찵������3for�찵������4for�̰�������5for�̰�������6for�̰�����
        cnt = 1;
        for i = 1:darktimePractice/length(min_seq)
            rand_one= randperm(length(min_seq));
            seq_order(cnt:cnt+length(min_seq)-1) = min_seq(rand_one);
            cnt = cnt + length(min_seq);
        end
        %nframes����ΪdarkInterval���ܺͼ��Ϻ����1000ms����Ϊ��β500ms���䰵�����һ�α䰵��Ҫ500ms��
        nframes = 10 + sum(darkInterval);
        
        %��ʽʵ�鿪ʼ
        %ָ����pre1
        if j == 1 
            img = imread(picPre1);
        else
            img = imread(picPre2);
        end
        textureIndex = Screen('MakeTexture', w, img);
        Screen('DrawTexture',w, textureIndex);
        vbl=Screen('Flip', w);              
        WaitSecs(2);
        is_true = 0;
        while (is_true == 0)
            [keyIsDown,sec,keyCode] = KbCheck;     
                if keyIsDown && keyCode(triggerKey)    
                   is_true = 1;              
                end
        end
        %��ϰʵ��
        %ָ����pra1
        if j == 1 
            img = imread(picPra1);
        else
            img = imread(picPra2);
        end
        textureIndex = Screen('MakeTexture', w, img);
        Screen('DrawTexture',w, textureIndex);
        vbl=Screen('Flip', w);              
        WaitSecs(2);
        is_true = 0;
        while (is_true == 0)
            [keyIsDown,sec,keyCode] = KbCheck;     
                if keyIsDown && keyCode(triggerKey)    
                   is_true = 1;              
                end
        end
        %ע�ӵ��ȳ���1��
        Screen('FillOval', w, uint8(white), fix_cord);
        vbl=Screen('Flip', w);               
        WaitSecs(1);
        %ѭ����ʼ
        for i = 1:nframes
            tempT = GetSecs;
            %��ߵ�λ�ñ任
            if (mod(i,2)==1)
                %���ѡһ������������λ��
                sortSeedRed1 = rand(ndots,1);
                [A,indexRed1] = sort(sortSeedRed1);
                changeRed1 = indexRed1(1:ndots/2,:);
                remainRed1 = indexRed1((ndots/2+1):ndots,:);
                rRed1(changeRed1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tRed1(changeRed1) = 2*pi*rand(ndots/2,1);                     
                csRed1(changeRed1,:) = [cos(tRed1(changeRed1)), sin(tRed1(changeRed1))]; 
                xyRed1(changeRed1,:) = [rRed1(changeRed1) rRed1(changeRed1)] .* csRed1(changeRed1,:); 

                sortSeedGreen1 = rand(ndots,1);
                [A,indexGreen1] = sort(sortSeedGreen1);
                changeGreen1 = indexGreen1(1:ndots/2,:);
                remainGreen1 = indexGreen1((ndots/2+1):ndots,:);
                rGreen1(changeGreen1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tGreen1(changeGreen1) = 2*pi*rand(ndots/2,1);                     
                csGreen1(changeGreen1,:) = [cos(tGreen1(changeGreen1)), sin(tGreen1(changeGreen1))]; 
                xyGreen1(changeGreen1,:) = [rGreen1(changeGreen1) rGreen1(changeGreen1)] .* csGreen1(changeGreen1,:); 

                xymatrixRed1 = transpose(xyRed1);
                xymatrixGreen1 = transpose(xyGreen1);

            else
                %ż����frameʱ��ʣ�µ���һ������������λ��
                rRed1(remainRed1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tRed1(remainRed1) = 2*pi*rand(ndots/2,1);                     
                csRed1(remainRed1,:) = [cos(tRed1(remainRed1)), sin(tRed1(remainRed1))]; 
                xyRed1(remainRed1,:) = [rRed1(remainRed1) rRed1(remainRed1)] .* csRed1(remainRed1,:); 

                rGreen1(remainGreen1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tGreen1(remainGreen1) = 2*pi*rand(ndots/2,1);                     
                csGreen1(remainGreen1,:) = [cos(tGreen1(remainGreen1)), sin(tGreen1(remainGreen1))]; 
                xyGreen1(remainGreen1,:) = [rGreen1(remainGreen1) rGreen1(remainGreen1)] .* csGreen1(remainGreen1,:); 

                xymatrixRed1 = transpose(xyRed1);
                xymatrixGreen1 = transpose(xyGreen1);      
            end;

            %�ж���˸�ͱ䰵
            if (countDark <= darktimePractice)
                if (countFrame < darkInterval(countDark))
                    if (countFrame == darkInterval(countDark)-SOA)
                        ifFlash = 1;
                    end
                    countFrame = countFrame + 1;
                else
                    countFrame = 1;
                    ifDark = 1;
                    countDark = countDark + 1;
                end
            end

            %��Χ����˸
            if (ifFlash == 1)
                rRight  = (rmax_out-rmin_out) * sqrt(rand(ndots_right,1))+rmin_out; 
                tRight  = 2*pi*rand(ndots_right,1);                    
                csRight = [cos(tRight), sin(tRight)];    
                xyRight = [rRight rRight] .* csRight;
                xymatrixRight = transpose(xyRight);
                switch seq_order(countDark)
                    case 1
                        color = 1;
                        colvectRight = colvectRed2;
                        sProbe(nDark)=1;
                    case 2
                        color = 1;
                        colvectRight = colvectGreen2;
                        sProbe(nDark)=2;
                    case 3
                        color = 1;
                        colvectRight = colvectBlack;
                        sProbe(nDark)=3;
                    case 4
                        color = 2;
                        colvectRight = colvectRed2;
                    case 5
                        color = 2;
                        colvectRight = colvectGreen2;
                    otherwise
                        color = 2;
                        colvectRight = colvectBlack;
                end
                Screen('DrawDots', w, xymatrixRight, s, colvectRight, centerRight,0); 
                ifFlash = 0;
            end

            %�������ɫ�䰵
            if (ifDark == 1)           
                if (color == 1) %��ɫ�䰵
                    red1 = zeros(3,ndots); 
                    red1(1,:) = 120; 
                    colvectRed1 = uint8(round(red1)); 
                    countColorDarkRed1 = countColorDarkRed1 +1;  %ʱ�����
                    if (countColorDarkRed1 > timeColorDark)  %�䰵500ms
                        red1 = zeros(3,ndots);
                        red1(1,:) = 255;
                        colvectRed1 = uint8(round(red1));
                        countColorDarkRed1 = 1;              
                        ifDark = 0;
                    end
                else               
                    green1 = zeros(3,ndots); %��ɫ�䰵
                    green1(2,:) = 60;
                    colvectGreen1 = uint8(round(green1)); 
                    countColorDarkGreen1 = countColorDarkGreen1 +1;    %ʱ�����
                    if (countColorDarkGreen1 > timeColorDark)  %�䰵500ms
                        green1 = zeros(3,ndots);
                        green1(2,:) = 128;
                        colvectGreen1 = uint8(round(green1));
                        countColorDarkGreen1 = 1;              
                        ifDark = 0;
                    end
                end
            end

            %��ע�ӵ�
            Screen('FillOval', w, uint8(white), fix_cord);  
            %��������̵�
            Screen('DrawDots', w, xymatrixRed1, s, colvectRed1, centerLeft,0);  
            Screen('DrawDots', w, xymatrixGreen1, s, colvectGreen1, centerLeft,0);          
            Screen('DrawingFinished', w); 
            vbl = Screen('Flip', w , vbl + 0.5*ifi);

            %�䰵ʱ��
            if countColorDarkGreen1 == 2               
                sSec(nDark) = 0;
                sPart(nDark) = j;
                tDark(nDark) = GetSecs - start;
                nDark = nDark+1;
                nPress = 1;
            end

            %��ⰴ��
            while  GetSecs - tempT <= 0.1
                [keyIsDown, secs, keyCode] = KbCheck;
                 assert(~keyCode(KbName('Escape')),onExit);
                if keyCode(responseKey)
                    if  secs-pressT > 0.3 && tDark(nDark-1)~=0      %�ų���������
                        tPress(nDark-1,nPress) = secs - start;           %����ʱ��
                        tRTs(nDark-1) = tPress(nDark-1,1) - tDark(nDark-1);     %��Ӧʱ=����ʱ��-�䰵ʱ��
                        nPress = nPress+1;
                        pressT = secs; 
                    end                
                end
            end  

        end;
        %ѭ������
        %��ʽʵ��sec1
        countFrame = 1;                    %ÿ�α䰵��ڼ���100ms
        countDark = 1;                     %�ڼ��α䰵
        ifDark = 0;                        %�жϵ��Ƿ�䰵   
        ifFlash = 0;                       %�ұ��Ƿ���˸
        darkInterval = zeros(1,darktime);  
        for i = 1:darktime
            darkInterval(i) = unidrnd(3)+17;
        end
        %����α�����
        min_seq= [1 2 3 3 4 5 6 6];
        seq_order = zeros(darktime,1);  %1for�찵������2for�찵������3for�찵������4for�̰�������5for�̰�������6for�̰�����
        cnt = 1;
        for i = 1:darktime/length(min_seq)
            rand_one= randperm(length(min_seq));
            seq_order(cnt:cnt+length(min_seq)-1) = min_seq(rand_one);
            cnt = cnt + length(min_seq);
        end 
        nframes = 10 + sum(darkInterval);
        %ָ����sec1
        img = imread(picSec1);
        textureIndex = Screen('MakeTexture', w, img);
        Screen('DrawTexture',w, textureIndex);
        vbl=Screen('Flip', w);               %��ʼˢһ����Ļ
        is_true = 0;
        while (is_true == 0)
            [keyIsDown,sec,keyCode] = KbCheck;     
                if keyIsDown && keyCode(triggerKey)    
                   is_true = 1;              
                end
        end 
        %ע�ӵ��ȳ���1��
        Screen('FillOval', w, uint8(white), fix_cord);
        vbl=Screen('Flip', w);               
        WaitSecs(1);
        %ѭ����ʼ
        for i = 1:nframes
            tempT = GetSecs;
            %��ߵ�λ�ñ任
            if (mod(i,2)==1)
                %���ѡһ������������λ��
                sortSeedRed1 = rand(ndots,1);
                [A,indexRed1] = sort(sortSeedRed1);
                changeRed1 = indexRed1(1:ndots/2,:);
                remainRed1 = indexRed1((ndots/2+1):ndots,:);
                rRed1(changeRed1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tRed1(changeRed1) = 2*pi*rand(ndots/2,1);                     
                csRed1(changeRed1,:) = [cos(tRed1(changeRed1)), sin(tRed1(changeRed1))]; 
                xyRed1(changeRed1,:) = [rRed1(changeRed1) rRed1(changeRed1)] .* csRed1(changeRed1,:); 

                sortSeedGreen1 = rand(ndots,1);
                [A,indexGreen1] = sort(sortSeedGreen1);
                changeGreen1 = indexGreen1(1:ndots/2,:);
                remainGreen1 = indexGreen1((ndots/2+1):ndots,:);
                rGreen1(changeGreen1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tGreen1(changeGreen1) = 2*pi*rand(ndots/2,1);                     
                csGreen1(changeGreen1,:) = [cos(tGreen1(changeGreen1)), sin(tGreen1(changeGreen1))]; 
                xyGreen1(changeGreen1,:) = [rGreen1(changeGreen1) rGreen1(changeGreen1)] .* csGreen1(changeGreen1,:); 

                xymatrixRed1 = transpose(xyRed1);
                xymatrixGreen1 = transpose(xyGreen1);

            else
                %ż����frameʱ��ʣ�µ���һ������������λ��
                rRed1(remainRed1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tRed1(remainRed1) = 2*pi*rand(ndots/2,1);                     
                csRed1(remainRed1,:) = [cos(tRed1(remainRed1)), sin(tRed1(remainRed1))]; 
                xyRed1(remainRed1,:) = [rRed1(remainRed1) rRed1(remainRed1)] .* csRed1(remainRed1,:); 

                rGreen1(remainGreen1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tGreen1(remainGreen1) = 2*pi*rand(ndots/2,1);                     
                csGreen1(remainGreen1,:) = [cos(tGreen1(remainGreen1)), sin(tGreen1(remainGreen1))]; 
                xyGreen1(remainGreen1,:) = [rGreen1(remainGreen1) rGreen1(remainGreen1)] .* csGreen1(remainGreen1,:); 

                xymatrixRed1 = transpose(xyRed1);
                xymatrixGreen1 = transpose(xyGreen1);      
            end;

            %�ж���˸�ͱ䰵
            if (countDark <= darktime)
                if (countFrame < darkInterval(countDark))
                    if (countFrame == darkInterval(countDark)-SOA)
                        ifFlash = 1;
                    end
                    countFrame = countFrame + 1;
                else
                    countFrame = 1;
                    ifDark = 1;
                    countDark = countDark + 1;
                end
            end

            %��Χ����˸
            if (ifFlash == 1)
                rRight  = (rmax_out-rmin_out) * sqrt(rand(ndots_right,1))+rmin_out; 
                tRight  = 2*pi*rand(ndots_right,1);                    
                csRight = [cos(tRight), sin(tRight)];    
                xyRight = [rRight rRight] .* csRight;
                xymatrixRight = transpose(xyRight);
                switch seq_order(countDark)
                    case 1
                        color = 1;
                        colvectRight = colvectRed2;
                        sProbe(nDark)=1;
                    case 2
                        color = 1;
                        colvectRight = colvectGreen2;
                        sProbe(nDark)=2;
                    case 3
                        color = 1;
                        colvectRight = colvectBlack;
                        sProbe(nDark)=3;
                    case 4
                        color = 2;
                        colvectRight = colvectRed2;
                    case 5
                        color = 2;
                        colvectRight = colvectGreen2;
                    otherwise
                        color = 2;
                        colvectRight = colvectBlack;
                end
                Screen('DrawDots', w, xymatrixRight, s, colvectRight, centerRight,0); 
                ifFlash = 0;
            end

            %�������ɫ�䰵
            if (ifDark == 1)           
                if (color == 1) %��ɫ�䰵
                    red1 = zeros(3,ndots); 
                    red1(1,:) = 120; 
                    colvectRed1 = uint8(round(red1)); 
                    countColorDarkRed1 = countColorDarkRed1 +1;  %ʱ�����
                    if (countColorDarkRed1 > timeColorDark)  %�䰵500ms
                        red1 = zeros(3,ndots);
                        red1(1,:) = 255;
                        colvectRed1 = uint8(round(red1));
                        countColorDarkRed1 = 1;              
                        ifDark = 0;
                    end
                else               
                    green1 = zeros(3,ndots); %��ɫ�䰵
                    green1(2,:) = 60;
                    colvectGreen1 = uint8(round(green1)); 
                    countColorDarkGreen1 = countColorDarkGreen1 +1;    %ʱ�����
                    if (countColorDarkGreen1 > timeColorDark)  %�䰵500ms
                        green1 = zeros(3,ndots);
                        green1(2,:) = 128;
                        colvectGreen1 = uint8(round(green1));
                        countColorDarkGreen1 = 1;              
                        ifDark = 0;
                    end
                end
            end

            %��ע�ӵ�
            Screen('FillOval', w, uint8(white), fix_cord);  
            %��������̵�
            Screen('DrawDots', w, xymatrixRed1, s, colvectRed1, centerLeft,0);  
            Screen('DrawDots', w, xymatrixGreen1, s, colvectGreen1, centerLeft,0);          
            Screen('DrawingFinished', w); 
            vbl = Screen('Flip', w , vbl + 0.5*ifi);

            %�䰵ʱ��
            if countColorDarkGreen1 == 2               
                sSec(nDark) = 1;
                sPart(nDark) = j;
                tDark(nDark) = GetSecs - start;
                nDark = nDark+1;
                nPress = 1;
            end

            %��ⰴ��
            while  GetSecs - tempT <= 0.1
                [keyIsDown, secs, keyCode] = KbCheck;
                 assert(~keyCode(KbName('Escape')),onExit);
                if keyCode(responseKey)
                    if  secs-pressT > 0.3 && tDark(nDark-1)~=0      %�ų���������
                        tPress(nDark-1,nPress) = secs - start;           %����ʱ��
                        tRTs(nDark-1) = tPress(nDark-1,1) - tDark(nDark-1);     %��Ӧʱ=����ʱ��-�䰵ʱ��
                        nPress = nPress+1;
                        pressT = secs; 
                    end                
                end
            end  

        end;  

        %��ʽʵ��sec2
        countFrame = 1;                    %ÿ�α䰵��ڼ���100ms
        countDark = 1;                     %�ڼ��α䰵
        ifDark = 0;                        %�жϵ��Ƿ�䰵   
        ifFlash = 0;                       %�ұ��Ƿ���˸
        darkInterval = zeros(1,darktime);  
        for i = 1:darktime
            darkInterval(i) = unidrnd(3)+17;
        end
        %����α�����
        min_seq= [1 2 3 3 4 5 6 6];
        seq_order = zeros(darktime,1);  %1for�찵������2for�찵������3for�찵������4for�̰�������5for�̰�������6for�̰�����
        cnt = 1;
        for i = 1:darktime/length(min_seq)
            rand_one= randperm(length(min_seq));
            seq_order(cnt:cnt+length(min_seq)-1) = min_seq(rand_one);
            cnt = cnt + length(min_seq);
        end
        nframes = 10 + sum(darkInterval);
        %ָ����sec2
        img = imread(picSec2);
        textureIndex = Screen('MakeTexture', w, img);
        Screen('DrawTexture',w, textureIndex);
        vbl=Screen('Flip', w);               %��ʼˢһ����Ļ
        is_true = 0;
        while (is_true == 0)
            [keyIsDown,sec,keyCode] = KbCheck;     
                if keyIsDown && keyCode(triggerKey)    
                   is_true = 1;              
                end
        end
        %ѭ����ʼ
        for i = 1:nframes
            tempT = GetSecs;
            %��ߵ�λ�ñ任
            if (mod(i,2)==1)
                %���ѡһ������������λ��
                sortSeedRed1 = rand(ndots,1);
                [A,indexRed1] = sort(sortSeedRed1);
                changeRed1 = indexRed1(1:ndots/2,:);
                remainRed1 = indexRed1((ndots/2+1):ndots,:);
                rRed1(changeRed1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tRed1(changeRed1) = 2*pi*rand(ndots/2,1);                     
                csRed1(changeRed1,:) = [cos(tRed1(changeRed1)), sin(tRed1(changeRed1))]; 
                xyRed1(changeRed1,:) = [rRed1(changeRed1) rRed1(changeRed1)] .* csRed1(changeRed1,:); 

                sortSeedGreen1 = rand(ndots,1);
                [A,indexGreen1] = sort(sortSeedGreen1);
                changeGreen1 = indexGreen1(1:ndots/2,:);
                remainGreen1 = indexGreen1((ndots/2+1):ndots,:);
                rGreen1(changeGreen1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tGreen1(changeGreen1) = 2*pi*rand(ndots/2,1);                     
                csGreen1(changeGreen1,:) = [cos(tGreen1(changeGreen1)), sin(tGreen1(changeGreen1))]; 
                xyGreen1(changeGreen1,:) = [rGreen1(changeGreen1) rGreen1(changeGreen1)] .* csGreen1(changeGreen1,:); 

                xymatrixRed1 = transpose(xyRed1);
                xymatrixGreen1 = transpose(xyGreen1);

            else
                %ż����frameʱ��ʣ�µ���һ������������λ��
                rRed1(remainRed1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tRed1(remainRed1) = 2*pi*rand(ndots/2,1);                     
                csRed1(remainRed1,:) = [cos(tRed1(remainRed1)), sin(tRed1(remainRed1))]; 
                xyRed1(remainRed1,:) = [rRed1(remainRed1) rRed1(remainRed1)] .* csRed1(remainRed1,:); 

                rGreen1(remainGreen1) = (rmax_in-rmin_in) * sqrt(rand(ndots/2,1))+rmin_in;                                   
                tGreen1(remainGreen1) = 2*pi*rand(ndots/2,1);                     
                csGreen1(remainGreen1,:) = [cos(tGreen1(remainGreen1)), sin(tGreen1(remainGreen1))]; 
                xyGreen1(remainGreen1,:) = [rGreen1(remainGreen1) rGreen1(remainGreen1)] .* csGreen1(remainGreen1,:); 

                xymatrixRed1 = transpose(xyRed1);
                xymatrixGreen1 = transpose(xyGreen1);      
            end;

            %�ж���˸�ͱ䰵
            if (countDark <= darktime)
                if (countFrame < darkInterval(countDark))
                    if (countFrame == darkInterval(countDark)-SOA)
                        ifFlash = 1;
                    end
                    countFrame = countFrame + 1;
                else
                    countFrame = 1;
                    ifDark = 1;
                    countDark = countDark + 1;
                end
            end

            %��Χ����˸
            if (ifFlash == 1)
                rRight  = (rmax_out-rmin_out) * sqrt(rand(ndots_right,1))+rmin_out; 
                tRight  = 2*pi*rand(ndots_right,1);                    
                csRight = [cos(tRight), sin(tRight)];    
                xyRight = [rRight rRight] .* csRight;
                xymatrixRight = transpose(xyRight);
                switch seq_order(countDark)
                    case 1
                        color = 1;
                        colvectRight = colvectRed2;
                        sProbe(nDark)=1;
                    case 2
                        color = 1;
                        colvectRight = colvectGreen2;
                        sProbe(nDark)=2;
                    case 3
                        color = 1;
                        colvectRight = colvectBlack;
                        sProbe(nDark)=3;
                    case 4
                        color = 2;
                        colvectRight = colvectRed2;
                    case 5
                        color = 2;
                        colvectRight = colvectGreen2;
                    otherwise
                        color = 2;
                        colvectRight = colvectBlack;
                end
                Screen('DrawDots', w, xymatrixRight, s, colvectRight, centerRight,0); 
                ifFlash = 0;
            end

            %�������ɫ�䰵
            if (ifDark == 1)           
                if (color == 1) %��ɫ�䰵
                    red1 = zeros(3,ndots); 
                    red1(1,:) = 120; 
                    colvectRed1 = uint8(round(red1)); 
                    countColorDarkRed1 = countColorDarkRed1 +1;  %ʱ�����
                    if (countColorDarkRed1 > timeColorDark)  %�䰵500ms
                        red1 = zeros(3,ndots);
                        red1(1,:) = 255;
                        colvectRed1 = uint8(round(red1));
                        countColorDarkRed1 = 1;              
                        ifDark = 0;
                    end
                else               
                    green1 = zeros(3,ndots); %��ɫ�䰵
                    green1(2,:) = 60;
                    colvectGreen1 = uint8(round(green1)); 
                    countColorDarkGreen1 = countColorDarkGreen1 +1;    %ʱ�����
                    if (countColorDarkGreen1 > timeColorDark)  %�䰵500ms
                        green1 = zeros(3,ndots);
                        green1(2,:) = 128;
                        colvectGreen1 = uint8(round(green1));
                        countColorDarkGreen1 = 1;              
                        ifDark = 0;
                    end
                end
            end

            %��ע�ӵ�
            Screen('FillOval', w, uint8(white), fix_cord);  
            %��������̵�
            Screen('DrawDots', w, xymatrixRed1, s, colvectRed1, centerLeft,0);  
            Screen('DrawDots', w, xymatrixGreen1, s, colvectGreen1, centerLeft,0);          
            Screen('DrawingFinished', w); 
            vbl = Screen('Flip', w , vbl + 0.5*ifi);

            %�䰵ʱ��
            if countColorDarkGreen1 == 2               
                sSec(nDark) = 2;
                sPart(nDark) = j;
                tDark(nDark) = GetSecs - start;
                nDark = nDark+1;
                nPress = 1;
            end

            %��ⰴ��
            while  GetSecs - tempT <= 0.1
                [keyIsDown, secs, keyCode] = KbCheck;
                 assert(~keyCode(KbName('Escape')),onExit);
                if keyCode(responseKey)
                    if  secs-pressT > 0.3 && tDark(nDark-1)~=0      %�ų���������
                        tPress(nDark-1,nPress) = secs - start;           %����ʱ��
                        tRTs(nDark-1) = tPress(nDark-1,1) - tDark(nDark-1);     %��Ӧʱ=����ʱ��-�䰵ʱ��
                        nPress = nPress+1;
                        pressT = secs; 
                    end                
                end
            end  

        end;    
        %ָ����end1
        if j == 1 
            endtime = endtime1;
        else
            endtime = endtime2;
        end
        img = imread(picEnd{j});
        textureIndex = Screen('MakeTexture', w, img);
        Screen('DrawTexture',w, textureIndex);
        vbl=Screen('Flip', w);               %��ʼˢһ����Ļ
        tempT_ = GetSecs;
        while  GetSecs - tempT_ <= endtime
                [keyIsDown, secs, keyCode] = KbCheck;
                 assert(~keyCode(KbName('Escape')),onExit);
        end
    end
    
    Priority(0);
    ShowCursor
    Screen('CloseAll');
catch
    Priority(0);
    ShowCursor
    Screen('CloseAll');
end
save(['ResultFBA_',ID,'_',datestr(now,30)]);
Screen('CloseAll');    %�����д��ڶ��ر�
ShowCursor;            %��ʾ���



