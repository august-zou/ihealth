class IHealth::API < Grape::API
  resource :data do
    get :hello do
        {:hello => "world"}
    end
    
    #url /data/temperature
    post :temperature do
      @tps = params[:temperature] 
      #@tmp = JSON.parse(tps)      
      #@tmp.each{ |tp| puts tp["email"]}
      PrivatePub.publish_to("/messages/new", :message => @tps)
      puts @tps
      @tps     
    end
  end
end