# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  dataT =  [25,25,25,25,25]
  dataECG =  new Array(100);
  dataPulse =  new Array(5);
  dataSpo2 =  new Array(5);
  
  for i in [0..100] 
    dataECG[i] = 0
  
  getTemperature = (data) ->
    dataTemperature =  [
        { step: '1', value: dataT[0] },
        { step: '2', value: dataT[1] },
        { step: '3', value: dataT[2] },
        { step: '4', value: dataT[3] },
        { step: '5', value: dataT[4] }
        ]
    return dataTemperature;

  getECG = (data) ->
    dataECG1 = []
    for i in [0..100] 
      tmp = { "step" : i.toString(),value: data[i] }
      dataECG1.push(tmp)
    #for(i=0;i<100;++i)
     #tmp = { "step" : i.toString() }
     #dataECG1.push(tmp)
     #console.log(tmp)
    
    return dataECG1;    

   
   getGraphData = (data) ->
     dataG = []
     for d in data 
       tmp = { "step" : i.toString(),value: d }
       dataG.push(tmp) 
     return dataG;
            
  PrivatePub.subscribe "/messages/new", (data, channel) ->
    temperature = Math.round(data.message *100 ) / 100
    $(".temperature").append("<li>"+ temperature.toString() + "</li>")
    $("#charts").empty()
    dataT.shift()
    #dataT.push(data.message)
    dataT.push(temperature )       
    new Morris.Line({   
      element: 'charts',
      data: getTemperature(dataT) ,
      xkey: 'step',
      ykeys: ['value'],
      parseTime: false,
      smooth: false,
      ymin:'auto 25',
      ymax:'auto 45',
      postUnits: 'C',
      goals:[35.0,37.0],
      goalLineColors:['#00ff00','#ff0000'],
      labels: ['value']
        })
        
  PrivatePub.subscribe "/messages/ecg", (data, channel) ->
    ecg= Math.round(data.message *100 ) / 100
    #$(".temperature").append("<li>"+ temperature.toString() + "</li>")
    $("#ecgCharts").empty()
    dataECG.shift()
    #dataT.push(data.message)
    dataECG.push(ecg )       
    new Morris.Line({   
      element: 'ecgCharts',
      data: getECG(dataECG) ,
      xkey: 'step',
      ykeys: ['value'],
      parseTime: false,
      lineWidth: 2,
      smooth: false,
      labels: ['value']
        })