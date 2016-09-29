namespace :tests do
  desc "Run all *_test.rb files in the tests directory"
  task :run do 
    Dir['./tests/*_test.rb'].each { |file| require file }
  end
end
