
require 'fileutils'
require 'git_cli'

include TR::FileUtils

RSpec.describe "Test GitVcs" do

  it 'creates repository and clone a repository' do

    #@ws = Gvcs::Workspace.new(@path)
    #expect(@ws.is_workspace?).to be false

    #st, res = @ws.vcs.init(@path)
    #expect(st).to be true
    #expect(@ws.clean?).to be true
    #expect(@ws.is_workspace?).to be true
    #expect(@ws.root_path == @path).to be true

    #st, res = @ws.vcs.init(@reposPath, true)
    #expect(st).to be true


    File.open(File.join(@path,"test.txt"),"w") do |f|
      f.puts "testing 123"
    end

    nd, nf = @ws.new_files
    expect(nf.length == 1).to be true
    expect(nf.first.path == "test.txt").to be true

    @ws.add(nf.first.path)
    nd, nf = @ws.new_files
    expect(nf.length == 0).to be true

    sd, sf = @ws.staged_files
    expect(sf.length == 1).to be true

    @ws.commit("Commiting test")

    sd, sf = @ws.staged_files
    expect(sf.length == 0).to be true
    expect(@ws.clean?).to be true

    st, res = @ws.logs
    expect(st).to be true
    expect((res =~ /Commiting test/) != nil).to be true

    @ws.add_remote("origin", @reposPath)
    @ws.push("origin")

    st, res = @ws.vcs.clone(@reposPath, @coPath)
    expect(st).to be true

    expect(File.is_same?(File.join(@path,"test.txt"), File.join(@coPath,"test.txt"))).to be true

    
    ## test remove from staging
    #File.open(File.join(@path,"test.txt"),"a+") do |f|
    #  f.puts "no la new content"
    #end

    #md, mf = @ws.modified_files
    #expect(mf.length == 1).to be true

    #@ws.add(mf.first.path)
    #md, mf = @ws.modified_files
    #expect(mf.length == 0).to be true

    #sd, sf = @ws.staged_files
    #expect(sf.length == 1).to be true

    #st, res = @ws.remove_from_staging(sf.first.path)
    #expect(st).to be true

    #sd, sf = @ws.staged_files
    #expect(sf.length == 0).to be true
    #md, mf = @ws.modified_files
    #expect(mf.length == 1).to be true

    ## test ignore
    #File.open(File.join(@path, "ignore me.txt"),"w") do |f|
    #  f.puts "this file meant to be ignored"
    #end

    #nd, nf = @ws.new_files
    #expect(nf.length == 1).to be true
    #expect(nf.first.path == "ignore me.txt").to be true

    #@ws.ignore(nf.first.path)

    #nd, nf = @ws.new_files
    #expect(nf.length == 1 && nf.first.path == ".gitignore").to be true

  end

end
