# Having issues with Guard recognizing file changes?
# If you are editing on a host but running rails in a vm
# try using polling mode:
#
#    bundle exec guard start -p -l3

interactor :simple

guard :rspec,:all_on_start => false, :all_after_pass => false, 
  :failed_mode => :focus,
  :cmd => "rspec" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

end
