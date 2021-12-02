function [X,Y,Z] = defMap4(mapRange)

% ��ʼ��������Ϣ
Data=load('mapInfor10001000.mat')
peakData=Data.peakData
% ���������������ڲ�ֵ�ж�·���Ƿ���ɽ�彻��
x = [];
for i = 1:mapRange(1)
    x = [x; ones(mapRange(2),1) * i];
end
y = (1:mapRange(2))';
y = repmat(y,length(peakData(:))/length(y),1);
peakData = reshape(peakData,length(peakData(:)),1);
[X,Y,Z] = griddata(x,y,peakData,...
    linspace(min(x),max(x),1000)',...
    linspace(min(y),max(y),1000));
surf(X,Y,Z)      % ������ͼ
shading flat     % ��С����֮�䲻Ҫ����
end