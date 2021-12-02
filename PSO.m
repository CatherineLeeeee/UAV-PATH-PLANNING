% ��2��������Ⱥ�㷨
% ���ߣ� Ally
% ���ڣ� 2021/07/10
clc
clear
close all

%% ��ά·���滮ģ�Ͷ���
startPos = [40, 129, 5];
goalPos = [951, 833, 10];

% �������ɽ���ͼ
mapRange = [1000,1000,120];              % ��ͼ�������߷�Χ
[X,Y,Z] = defMap4(mapRange);

%% ��ʼ��������
N = 100;           % ��������
M = 50;            % ��������
pointNum = 4;      % ÿһ�����Ӱ�������λ�õ�
w = 1.2;           % ����Ȩ��
c1 = 1.5;            % ���Ȩ��
c2 = 1.5;            % ��֪Ȩ��

% ����λ�ý���
posBound = [[0,0,10]',[1000,1000,60]'];

% �����ٶȽ���
alpha = 0.1;
velBound(:,2) = alpha*(posBound(:,2) - posBound(:,1));
velBound(:,1) = -velBound(:,2);
% velBound(3,1)=-4;
% velBound(3,2)=4;

%% ��Ⱥ��ʼ��
% ��ʼ��һ���յ����ӽṹ��
particles.pos= [];
particles.v = [];
particles.fitness = [];
particles.path = [];
particles.Best.pos = [];
particles.Best.fitness = [];
particles.Best.path = [];

% ����M�����ӵĽṹ��
particles = repmat(particles,M,1);

% ��ʼ��ÿһ������������
GlobalBest.fitness = [inf,inf];

% ��һ���ĸ������ӳ�ʼ��
for i = 1:M 
    % ���Ӱ�����̬�ֲ��������
    particles(i).pos.x = unifrnd(posBound(1,1),posBound(1,2),1,pointNum);
    particles(i).pos.x=sort(particles(i).pos.x);
    particles(i).pos.y = unifrnd(posBound(2,1),posBound(2,2),1,pointNum);
    particles(i).pos.y=sort(particles(i).pos.y);
    particles(i).pos.z = unifrnd(posBound(3,1),posBound(3,2),1,pointNum);
    %particles(i).pos.z=sort(particles(i).pos.z);
    
    % ��ʼ���ٶ�
%     particles(i).v.x = zeros(1, pointNum);
%     particles(i).v.y = zeros(1, pointNum);
%     particles(i).v.z = zeros(1, pointNum);
    particles(i).v.x=unifrnd(velBound(1,1),velBound(1,2),1,pointNum);
    particles(i).v.y=unifrnd(velBound(2,1),velBound(2,2),1,pointNum);
    particles(i).v.z=unifrnd(velBound(3,1),velBound(3,2),1,pointNum);
    % ��Ӧ��
    [flag,fitness,path] = calFitness(startPos, goalPos,X,Y,Z, particles(i).pos);
    
    % ��ײ����ж�
    if flag == 1
        % ��flag=1��������·�������ϰ����ཻ����������Ӧ��ֵ
        particles(i).fitness = 1000*fitness;
        particles(i).path = path;
    else
        % ���򣬱�������ѡ���·��
        particles(i).fitness = fitness;
        particles(i).path = path;
    end
    
    % ���¸������ӵ�����
    particles(i).Best.pos = particles(i).pos;
    particles(i).Best.fitness = particles(i).fitness;
    particles(i).Best.path = particles(i).path;
    
    % ����ȫ������
    if (particles(i).Best.fitness(1) < GlobalBest.fitness(1))&(particles(i).Best.fitness(2) < GlobalBest.fitness(2))
        GlobalBest = particles(i).Best;
    end
end

% ��ʼ��ÿһ����������Ӧ�ȣ����ڻ���Ӧ�ȵ���ͼ
fitness_beat_iters = zeros(N,2);

%% ѭ��
for iter = 1:N
    for i = 1:M  
        % �����ٶ�
        particles(i).v.x = w*particles(i).v.x ...
            + c1*rand([1,pointNum]).*(particles(i).Best.pos.x-particles(i).pos.x) ...
            + c2*rand([1,pointNum]).*(GlobalBest.pos.x-particles(i).pos.x);
        particles(i).v.y = w*particles(i).v.y ...
            + c1*rand([1,pointNum]).*(particles(i).Best.pos.y-particles(i).pos.y) ...
            + c2*rand([1,pointNum]).*(GlobalBest.pos.y-particles(i).pos.y);
        particles(i).v.z = w*particles(i).v.z ...
            + c1*rand([1,pointNum]).*(particles(i).Best.pos.z-particles(i).pos.z) ...
            + c2*rand([1,pointNum]).*(GlobalBest.pos.z-particles(i).pos.z);

        % �ж��Ƿ�λ���ٶȽ�������
        particles(i).v.x = min(particles(i).v.x, velBound(1,2));
        particles(i).v.x = max(particles(i).v.x, velBound(1,1));
        particles(i).v.y = min(particles(i).v.y, velBound(2,2));
        particles(i).v.y = max(particles(i).v.y, velBound(2,1));
        particles(i).v.z = min(particles(i).v.z, velBound(3,2));
        particles(i).v.z = max(particles(i).v.z, velBound(3,1));
        
        % ��������λ��
        particles(i).pos.x = particles(i).pos.x + particles(i).v.x;
        particles(i).pos.y = particles(i).pos.y + particles(i).v.y;
        particles(i).pos.z = particles(i).pos.z + particles(i).v.z;

        % �ж��Ƿ�λ������λ�ý�������
        particles(i).pos.x = max(particles(i).pos.x, posBound(1,1));
        particles(i).pos.x = min(particles(i).pos.x, posBound(1,2));
        particles(i).pos.y = max(particles(i).pos.y, posBound(2,1));
        particles(i).pos.y = min(particles(i).pos.y, posBound(2,2));
        particles(i).pos.z = max(particles(i).pos.z, posBound(3,1));
        particles(i).pos.z = min(particles(i).pos.z, posBound(3,2));
        
        % ��Ӧ�ȼ���
        [flag,fitness,path] = calFitness(startPos, goalPos,X,Y,Z, particles(i).pos);
        
        % ��ײ����ж�
        if flag == 1
            % ��flag=1��������·�������ϰ����ཻ����������Ӧ��ֵ
            particles(i).fitness = 1000*fitness;
            particles(i).path = path;
        else
            % ���򣬱�������ѡ���·��
            particles(i).fitness = fitness;
            particles(i).path = path;
        end
        
        % ���¸�����������
        if (particles(i).fitness(1) < particles(i).Best.fitness(1))&(particles(i).fitness(2) < particles(i).Best.fitness(2))
            particles(i).Best.pos = particles(i).pos;
            particles(i).Best.fitness = particles(i).fitness;
            particles(i).Best.path = particles(i).path;
            
            % ����ȫ����������
            if (particles(i).Best.fitness(1) < GlobalBest.fitness(1))&(particles(i).Best.fitness(2) < GlobalBest.fitness(2))
                GlobalBest = particles(i).Best;
            end
        end
    end
    
    
    % ��ÿһ�����������Ӹ�ֵ��fitness_beat_iters
    fitness_beat_iters(iter,1) = GlobalBest.fitness(1);
    fitness_beat_iters(iter,2) = GlobalBest.fitness(2);
    
    % �������д�����ʾÿһ������Ϣ
    disp(['��' num2str(iter) '��:' '������Ӧ��1 = ' num2str(fitness_beat_iters(iter,1))  '������Ӧ��2 = ' num2str(fitness_beat_iters(iter,2))]);
    
    % ��ͼ
    plotFigure(startPos,goalPos,X,Y,Z,GlobalBest);
    pause(0.001);
end

%% ���չʾ
% ������С��Ӧ�ȣ�ֱ�߾���
fitness_best = norm(startPos - goalPos);
disp([ '����������Ӧ�� = ' num2str(fitness_best)]);

% ����Ӧ�ȵ���ͼ
figure
plot(fitness_beat_iters(:,1),'LineWidth',2);
xlabel('��������');
ylabel('������Ӧ��1');

figure
plot(fitness_beat_iters(:,2),'LineWidth',2);
xlabel('��������');
ylabel('������Ӧ��2');