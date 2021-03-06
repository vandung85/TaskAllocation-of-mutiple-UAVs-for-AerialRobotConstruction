function [time_cost, min_dist,min_time_travelled]=AntColonyAlgorithmMethod(UAV_position,Target_position,UAV_number,UAV_speed,task_number,...
    ant_num_TA, iteratornum_TA, maxT,task_fixed_number, ant_num_PP, iteratornum_PP, SizeofMap,Color)
%%
tic;
travelled_time = zeros(1,UAV_number);
[best_ant_path,min_dist,travelled_time,Best_path] = AntColonyTaskAllocation(UAV_position,Target_position,UAV_number,UAV_speed,task_number,...
    ant_num_TA, iteratornum_TA, maxT,task_fixed_number, ant_num_PP, iteratornum_PP,travelled_time);
toc;
time_cost=toc;
min_time_travelled = max(travelled_time);

Best_path(all(Best_path==0,2),:) = [];
Best_Strategy_entire = Best_path;

[row,col]=find(best_ant_path==1);

for i = 1: UAV_number
    mid = find(col==i);
    possibility(i) =length(mid);
end
% %
% %         task_number_imme = task_number;
% Best_Strategy_entire = zeros( max(possibility),UAV_number);
% for i = 1: UAV_number
%     mid = find(col==i);
%     for j = 1: length(mid)
%         Best_Strategy_entire(j,i)=row(mid(j));
%     end
% end

%%  Display the task allcocation strategy
count = ones(1,UAV_number); % count which task the UAV is handling
while (isempty (Target_position) == 0)
    
    for i = 1: UAV_number
        Best_Strategy(1,i) = Best_Strategy_entire(count(i),i);
    end
    
    for j = 1:size(Best_Strategy,2)
        if(Best_Strategy(1,j) == 0)
            %Best_Strategy_updated(i,j)=0;
            %Target_position(Best_Strategy(1,j),:) = UAV_position( j, :);
            UAV_step(j,:)=[0, 0];
            %task_number=task_number+1;
        else
            %     end
            difference(j,:)=Target_position(Best_Strategy(j),:)-UAV_position(j,:);
            UAV_step(j,:)= (UAV_speed(j)/norm(difference(j,:))) * difference(j,:);
            
            
            %             %     for j =1: size(Best_Strategy,2)
            %             difference(j,:)=Target_position(Best_Strategy(j),:)-UAV_position(j,:);
            %             if (difference(j,1)==0)
            %                 angle(j)= pi/2;
            %             else
            %                 angle(j)= atan(difference(j,2)/difference(j,1));
            %             end
            %             %     end
            %             %end
            %
            %             % for i= 1: size(Best_Strategy,1)
            %             %     for j= 1: size(Best_Strategy,2)
            %             if (difference(j,1) > 0)
            %                 UAV_step(j,1)= UAV_speed(j)*cos(angle(j));
            %                 UAV_step(j,2)= UAV_speed(j)*sin(angle(j));
            %             elseif(difference(j,1) < 0)
            %                 UAV_step(j,1)= -UAV_speed(j)*cos(angle(j));
            %                 UAV_step(j,2)= -UAV_speed(j)*sin(angle(j));
            %             elseif ((difference(j,1) == 0)&& (difference(j,2) > 0))
            %                 UAV_step(j,1)= UAV_speed(j)*cos(angle(j));
            %                 UAV_step(j,2)= UAV_speed(j)*sin(angle(j));
            %             elseif ((difference(j,1) == 0)&& (difference(j,2) < 0))
            %                 UAV_step(j,1)= - UAV_speed(j)*cos(angle(j));
            %                 UAV_step(j,2)= - UAV_speed(j)*sin(angle(j));
            %             end
        end
    end
    
    [UAV_position_new,Target_position_new,task_number, count] = Draw_Strategy_AntColony(UAV_position,Target_position,...
        Best_Strategy, SizeofMap, UAV_step, UAV_speed, task_number, count, Color);
    if (task_number == 0)
        break;
    end
    
    for i = 1: size(count,2)
        if (count(i) >max(possibility))
            count(i) = max(possibility);
        end
    end
    
    UAV_position = UAV_position_new;
end