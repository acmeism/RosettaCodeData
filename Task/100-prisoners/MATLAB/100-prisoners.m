function [randSuccess,idealSuccess]=prisoners(numP,numG,numT)
    %numP is the number of prisoners
    %numG is the number of guesses
    %numT is the number of trials
    randSuccess=0;

    %Random
    for trial=1:numT
        drawers=randperm(numP);
        won=1;
        for i=1:numP
            correct=0;
            notopened=drawers;
            for j=1:numG
                ind=randi(numel(notopened));
                m=notopened(ind);
                if m==i
                    correct=1;
                    break;
                end
                notopened(ind)=[];
            end
            if correct==0
                won=0;
                break;
            end
        end
        randSuccess=randSuccess*(trial-1)/trial+won/trial;
    end


    %Ideal
    idealSuccess=0;

    for trial=1:numT
        drawers=randperm(numP);
        won=1;
        for i=1:numP
            correct=0;
            guess=i;
            for j=1:numG
                m=drawers(guess);
                if m==i
                    correct=1;
                    break;
                end
                guess=m;
            end
            if correct==0
                won=0;
                break;
            end
        end
        idealSuccess=idealSuccess*(trial-1)/trial+won/trial;
    end
    disp(['Probability of success with random strategy: ' num2str(randSuccess*100) '%']);
    disp(['Probability of success with ideal strategy: ' num2str(idealSuccess*100) '%']);
end
