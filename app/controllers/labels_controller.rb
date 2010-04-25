class LabelsController < ApplicationController
  before_filter :require_user
  
  def index
    @labels = current_user.labels
    @label = Label.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @labels }
    end    
  end

  def show
    @label = current_user.labels.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @label }
    end
  end

  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @label }
    end
  end

  def edit
    @label = current_user.labels.find(params[:id])
  end

  def create
    @label = current_user.labels.build(params[:label])

    respond_to do |format|
      if @label.save
        if request.xhr?
          return render :partial => 'label', :object => @label
        else
          flash[:notice] = 'Label was successfully created.'
          format.html { redirect_to(@label) }
          format.xml  { render :xml => @label, :status => :created, :location => @label }
        end
      else
        if request.xhr?
          return render :action => 'new', :layout => false, :status => :unprocessable_entity
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }          
        end        
      end
    end
  end

  def update
    @label = current_user.labels.find(params[:id])

    respond_to do |format|
      if @label.update_attributes(params[:label])
        if request.xhr?
          format.xml  { head :ok }          
        else        
          flash[:notice] = 'Label was successfully updated.'
          format.html { redirect_to(labels_path) }
          format.xml  { head :ok }
        end
      else
        if request.xhr?
          format.xml  { head :unprocessable_entity }          
        else                
          format.html { render :action => "edit" }
          format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @label = current_user.labels.find(params[:id])
    @label.destroy

    respond_to do |format|
      if request.xhr?
        return head :ok
      else
        format.html { redirect_to(labels_url) }
        format.xml  { head :ok }
      end
    end
  end
end
