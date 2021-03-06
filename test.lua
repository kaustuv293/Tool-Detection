require 'nn'
require 'cudnn'
require 'cunn'
local matio = require 'matio'

print('Loading test data...')
TestData = torch.div(matio.load('data/testData.mat','testData'):float(),255)
print('test data loaded!')


model = torch.load('Results/Net_cnn')

Net_pred = torch.Tensor(TestData:size(1),8)
batchSize = 64
local SizeData = TestData:size(1)
SizeBatch = math.floor(TestData:size(1)/batchSize)
timer = torch.Timer()
  local yt,x;
  local num = 1;
  for NumBatches=1,SizeBatch do	    
  	print(NumBatches .. '/' .. SizeBatch)
	    x = TestData[{{num,num+batchSize-1},{},{},{}}]:cuda()	   
	    y = model:forward(x)	    
	    Net_pred[{{num,num+batchSize-1},{}}] = y:float()
	    num = num + batchSize
   end

   if(TestData:size(1)%batchSize ~= 0) then	    
	    x = TestData[{{num,TestData:size(1)},{},{},{}}]:cuda()	   
	    y = model:forward(x)
	    Net_pred[{{num,TestData:size(1)},{}}] = y:float()
	end

matio.save('Results/Net_CNNpred.mat',Net_pred); 
print(timer:time().real)