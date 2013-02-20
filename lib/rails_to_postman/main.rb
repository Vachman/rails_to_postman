module RailsToPostman
  
  def self.export_routes
    load Rails.application.root.join('config/routes.rb') 
    resources = get_routes
    doc = render_postman_json_from(resources)
    save_to_file(doc)
  end
  
  def self.normalise_route(route, path_prefix = nil)
    route.verb.source.split('|').map do |verb|
      {
         :id   => @_route_counter+=1,
         :name => route.name,
         :verb => verb.gsub(/[$^]/, ''),
         :path => path_prefix.to_s + route.path.spec.to_s.sub('(.:format)', ''),
         :reqs => route.requirements
      }
    end
  end

  def self.get_routes
    @_route_counter = 0
    routes = []
    Rails.application.routes.routes.each do |route|
      next if route.app.is_a?(ActionDispatch::Routing::Mapper::Constraints)
      routes << normalise_route(route)[0] 
    end
    grouped_routes(routes.compact)
  end
     
  def self.grouped_routes(routes)
    routes.group_by { |r| r[:reqs][:controller] }
  end
  
  def self.render_postman_json_from(resources)
    collection_id = Rails.application.class.parent.to_s.downcase
    collection_name = Rails.application.class.parent.to_s 
    


    postman_json = {
      id: collection_id,
      name: collection_name,
      timestamp: '1360664941208',
      order: [],
      requests: []
    }
    
    resources.each do |resource, routes|
      postman_json[:order] << "resource##{resource}"
      postman_json[:requests] << {
        collectionId: collection_id,
        id: "resource##{resource}",
        name: resource.upcase,
        description: "#{resource.capitalize} resources",
        url: "/#{resource}",
        method: "RESOURCES",
        headers: "",
        data: [],
        dataMode: "params",
        timestamp: 0,
        responses: [],
        version: 2
      }
      
      routes.each do |route|
        postman_json[:order] << "#{resource}##{route[:reqs][:action]}"
        postman_json[:requests] << {
          collectionId: collection_id,
          id: "#{resource}##{route[:reqs][:action]}",
          name: "#{route[:reqs][:action]}",
          description: "#{resource.capitalize} '#{route[:reqs][:action]}' method",
          url: "{{url}}#{route[:path]}?token={{token}}",
          method: route[:verb],
          headers: "",
          data: [],
          dataMode: "params",
          timestamp: 0,
          responses: [],
          version: 2
        }
      end
    end 
    postman_json
  end  

  def self.save_to_file(doc)
    file_path = "tmp/#{Rails.application.class.parent.to_s.downcase}_routes_for_postman.json"
    output_file = File.open( file_path, 'w') 
    output_file << doc.to_json
    output_file.close
    puts "Rails to Postman - routes exported to: '#{file_path}'" 
  end
end