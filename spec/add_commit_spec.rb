

RSpec.describe "Git add, remove and commit" do

  it 'add, remove file from staging and commit' do

    File.open(File.join(@path,"test.txt"),"w") do |f|
      f.puts "new content"
    end

    File.open(File.join(@path,"test2.txt"),"w") do |f|
      f.puts "another new file content"
    end

    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 0).to be true
    expect(@ws.newFiles.length == 2).to be true
    expect(@ws.delFiles.length == 0).to be true

    @ws.add(@ws.newFiles)

    expect(@ws.stgFiles.length == 2).to be true
    expect(@ws.modFiles.length == 0).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true

    @ws.commit("Commiting test")

    expect(@ws.clear?)
    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 0).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true


    File.open(File.join(@path,"test.txt"),"a+") do |f|
      f.puts "adding new content for commit 2"
    end
    File.open(File.join(@path,"test2.txt"),"a+") do |f|
      f.puts "adding new content for commit 2 - 2"
    end


    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 2).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true

    @ws.commit("Commiting test 2", { files: @ws.modFiles })

    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 0).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true


    File.open(File.join(@path,"test.txt"),"a+") do |f|
      f.puts "adding new content for commit all"
    end
    File.open(File.join(@path,"test2.txt"),"a+") do |f|
      f.puts "adding new content blah blah for commit all"
    end


    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 2).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true

    @ws.commit_all("Commit all tracked files")

    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 0).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true

    File.open(File.join(@path,"test.txt"),"a+") do |f|
      f.puts "adding new content for staging remove"
    end

    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 1).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true

    @ws.add(@ws.modFiles)

    expect(@ws.stgFiles.length == 1).to be true
    expect(@ws.modFiles.length == 0).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true

    st, res = @ws.remove_staging(@ws.stgFiles)
    expect(st).to be true

    expect(@ws.stgFiles.length == 0).to be true
    expect(@ws.modFiles.length == 1).to be true
    expect(@ws.newFiles.length == 0).to be true
    expect(@ws.delFiles.length == 0).to be true

    st, res = @ws.remove_vcs(@ws.modFiles)
    expect(st).to be true

    # one modified file after move -> 
    # 1 new file + 1 staegd file (tell git to delete)
    expect(@ws.stgFiles.length == 1).to be true
    expect(@ws.modFiles.length == 0).to be true
    expect(@ws.newFiles.length == 1).to be true
    expect(@ws.delFiles.length == 0).to be true

  end

end
