require 'builder'
if Rails.env.production?
require 'puppet'
end

class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js
  respond_to :xml, only: [:index, :index_certified]
  
  # -------------------
  #  Method: Display awaiting nodes for certification
  # -------------------
  def index
    output_command = Node.puppetca_command
    if output_command.blank?
      flash.now[:notice] = "No current node to certify"
    else
      @nodes = output_command.split(/\n/).map do | line |
        name = line.split(/\s+/)[1].gsub(/"/,'')    # Get the fqdn
        Node.where('name'=>name).first_or_create    # Checks if the node already exists, or creates it.
      end
    end

    respond_to do |format|
      format.xml { render :xml => node_xml(false) }
      format.html
    end

  end
  
  
  def index_certified
#	@nodes = Node.where('certified' => true)   # Get certified nodes only
    # @nodes = Node.all
    @nodes = Rails.cache.fetch("node_#{Node.maximum('updated_at')}") do
      Node.all
    end

    @nodecount = @nodes.count

    respond_to do |format|
      format.xml { render :xml => node_xml }
      format.html
    end
  end
    
    
  # -------------------
  #  Method: Revoke certificate on puppet master. Forbide access for the nodes
  # -------------------
  def revoke
    if params.has_key?(:ids)
      Node.find(params[:ids]).each do |id|   # Revoke node
        system("sudo puppet cert clean "+id.name)
        id.update_attributes('certified' => false)
      end
      node_list = Node.where("id"=>params[:ids]).map do |noeud| noeud.name end
      redirect_to index_certified_nodes_path, notice: "Following nodes have been revoked from puppet: <br /><ul><li>"+ node_list.join("</li><li>") + "</li></ul>"
      
      flash.now[:notice] = "[#{session[:user_uid]}] has revoked those nodes '#{node_list}'"
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has revoked those nodes '#{node_list}'"
    else
      redirect_to index_certified_nodes_path, alert: "No node has been selected. Please tick the box to revoke a node."
    end
  end
  # -------------------
  
  
  # -------------------
  #  Method: Certify clients' certificate on puppet master. Allow access to puppetmaster for the nodes
  # -------------------
  def certify	
    if params.has_key?(:ids)
      Node.find(params[:ids]).each do |id|    # Certify nodes
        system("sudo puppet cert sign "+id.name)
        id.update_attributes('certified' => true)
      end
      node_list = Node.where("id"=>params[:ids]).map do |noeud| noeud.name end
      redirect_to nodes_path, notice: "Following nodes have been authorized to get puppet updates: <br /><ul><li>"+ node_list.join("</li><li>") + "</li></ul>"
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has certified those nodes '#{node_list}'"
    else
      redirect_to nodes_path, alert: "No node has been selected. Please tick the box to certify a node."
    end
  end
  # -------------------
  
  
  def show
  end

  def update
  end

  def destroy
    MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has removed those nodes '#{@node.name}'"
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_node
    @node = Node.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def node_params
    params.require(:node).permit(:name)
  end

  def node_xml(certified = true)
    nodes = Node.where('certified' => certified)
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.projects do
      unless @nodes.nil?
        nodes.each { |node|
          xml.node("name" => node.name, "decription" => node.description, "tags" => "", "hostname" => node.name, "osArch" => node.osarch, "osFamily" => node.osfamily, "osName" => node.osname, "osCodename" => node.oscodename, "osVersion" => node.osversion, "username" => "rundeckcs" )}
      end
    end
  end
end
