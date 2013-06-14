# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  dataT =  [25,25,25,25,25]
  dataECG =  new Array(100);
  dataPulse =  new Array(5);
  dataSpo2 =  new Array(5);
  dataBr =  new Array(100);
  
  
  getGraphData = (data) ->
    dataG = []
    for d,i in data 
      tmp = { "step" : i.toString(),value: d }
      dataG.push(tmp) 
    return dataG;
    
  getCurrentTime = (flag) ->
    currentTime = ""
    myDate = new Date()
    year = myDate.getFullYear();
    month = parseInt(myDate.getMonth().toString()) + 1 #month是从0开始计数的，因此要 + 1
    if month < 10
      month = "0" + month.toString() 
    date = myDate.getDate()
    if date < 10 
      date = "0" + date.toString()    
    hour = myDate.getHours();
    if hour < 10
      hour = "0" + hour.toString()    
    minute = myDate.getMinutes()
    if minute < 10
      minute = "0" + minute.toString()    
    second = myDate.getSeconds()
    if second < 10
      second = "0" + second.toString()   
    if flag == "0"   
      currentTime = year.toString() + month.toString() + date.toString() + hour.toString() +    minute.toString() + second.toString() #返回时间的数字组合    
    else if flag == "1"
      currentTime = year.toString() + "-" + month.toString() + "-" + date.toString() + " " + hour.toString() + ":" + minute.toString() + ":" + second.toString() #以时间格式返回
    return currentTime
  
  #init
  for i in [0..100] 
    dataECG[i] = 0 
    dataBr[i] = 0
    
  for i in [0..5] 
    dataPulse[i] = 0
  
  new Morris.Line({   
    element: 'ecgChart',
    data: getGraphData(dataECG) ,
    xkey: 'step',
    ykeys: ['value'],
    parseTime: false,
    lineWidth: 2,
    smooth: false,
    pointSize:0,
    labels: ['value']
      })
      
  new Morris.Line({   
    element: 'brChart',
    data: getGraphData(dataBr) ,
    xkey: 'step',
    ykeys: ['value'],
    parseTime: false,
    lineWidth: 2,
    smooth: false,
    pointSize:0,
    labels: ['value']
      })
      
  new Morris.Line({   
    element: 'pulseChart',
    data: getGraphData(dataPulse) ,
    xkey: 'step',
    ykeys: ['value'],
    parseTime: false,
    lineWidth: 2,
    smooth: false,
    labels: ['value']
      })
  #end init
    
  updateWeb = ->
    $(".temperature").empty()
    $("#ecgChart").empty()
    $("#brChart").empty()
    $("#pulseChart").empty()  
    $("#loginDate").text(getCurrentTime("1"))
    #update ecg chart
    new Morris.Line({   
      element: 'ecgChart',
      data: getGraphData(dataECG) ,
      xkey: 'step',
      ykeys: ['value'],
      parseTime: false,
      lineWidth: 2,
      smooth: false,
      pointSize:0,
      
      labels: ['value']
        })
    #update breath chart
    new Morris.Line({   
      element: 'brChart',
      data: getGraphData(dataBr) ,
      xkey: 'step',
      ykeys: ['value'],
      parseTime: false,
      lineWidth: 2,
      smooth: true,
      pointSize:0,
      labels: ['value']
        })
    #update pulse chart
    new Morris.Line({   
      element: 'pulseChart',
      data: getGraphData(dataPulse) ,
      xkey: 'step',
      ykeys: ['value'],
      parseTime: false,
      lineWidth: 2,
      smooth: false,
      labels: ['value']
        })


  setInterval updateWeb,1000
  
            
  PrivatePub.subscribe "/temperature", (data, channel) ->
    temperature = Math.round(data.message *100 ) / 100
    $(".temperature").append("<li>"+ temperature.toString() + "</li>")
    $("#tpChart").empty()
    
    dataT.shift()
    dataT.push(temperature)     
      
    new Morris.Line({   
      element: 'tpChart',
      data: getGraphData(dataT) ,
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
        
  PrivatePub.subscribe "/ecg", (data, channel) ->
    ecg= Math.round(data.message *100 ) / 100
    #$("#ecgChart").empty()
    
    dataECG.shift()
    dataECG.push(ecg )       
    ###
    new Morris.Line({   
      element: 'ecgChart',
      data: getGraphData(dataECG) ,
      xkey: 'step',
      ykeys: ['value'],
      parseTime: false,
      lineWidth: 2,
      smooth: false,
      labels: ['value']
        })
  ###
  PrivatePub.subscribe "/ecgs", (data, channel) ->
    ecgs= data.message
    $.each ecgs, (idx,item) ->
      dataECG.shift()
      dataECG.push(item.ecg)
       

        
  PrivatePub.subscribe "/pulse_spo2", (data, channel) ->
    pulse = Math.round(data.pulse *100 ) / 100
    spo2 =Math.round(data.spo2 *100 ) / 100
    $("#heartData").text(pulse.toString())
    $("#spo2Data").text(spo2.toString())
    dataPulse.shift()
    dataPulse.push(pulse)    

      
  PrivatePub.subscribe "/breath", (data, channel) ->
    breath= Math.round(data.breath *100 ) / 100    
    $("#brChart").empty()
    dataBr.shift()
    dataBr.push(br)       
    new Morris.Line({   
      element: 'brChart',
      data: getGraphData(dataBr) ,
      xkey: 'step',
      ykeys: ['value'],
      parseTime: false,
      lineWidth: 2,
      smooth: false,
      labels: ['value']
        })
        
  PrivatePub.subscribe "/breaths", (data, channel) ->
    breaths= data.breaths
    $.each breaths, (idx,item) ->
      dataBr.shift()
      dataBr.push(item.breath)
     
