class TasksController < ApplicationController
  before_filter :require_user
  
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = current_user.tasks.all
    @task = Task.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end    
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = current_user.tasks.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = current_user.tasks.build(params[:task])

    respond_to do |format|
      if @task.save
        if request.xhr?
          return render :partial => 'task', :object => @task
        else
          flash[:notice] = 'Task was successfully created.'
          format.html { redirect_to(@task) }
          format.xml  { render :xml => @task, :status => :created, :location => @task }
        end
      else
        if request.xhr?
          return render :action => 'new', :layout => false, :status => :unprocessable_entity
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }          
        end        
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(@task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
end
