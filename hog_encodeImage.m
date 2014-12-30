function psi = hog_encodeImage( im,cache )


if ~iscell(im), im = {im} ; end
psi = cell(1,numel(im)) ;
if numel(im) > 1
  parfor i = 1:numel(im)
    psi{i} = processOne(im{i}, cache) ;
  end
elseif numel(im) == 1
  psi{1} = processOne(im{1}, cache) ;
end
psi = cat(2, psi{:}) ;

% --------------------------------------------------------------------
function psi = processOne(im, cache)
% --------------------------------------------------------------------
if isstr(im)
  if ~isempty(cache)
    psi = getFromCache(im, cache) ;%已经在cache里存在的就直接存取
    if ~isempty(psi), return ; end
  end
  fprintf('encoding image %s\n', im) ;
end

psi = encodeOne(im) ;

if isstr(im) & ~isempty(cache)
  storeToCache(im, cache, psi) ;
end

% --------------------------------------------------------------------
function psi = encodeOne( im)
% --------------------------------------------------------------------
cellSize = 8;
i=0;
i=i+1;
if isstr(im)
  if exist(im, 'file')
    fullPath = im ;
  else
    fullPath = fullfile('data','images',[im '.jpg']) ;
  end
  im =imread(fullPath) ;
 im=single(imresize(im,[48,48]));
end;
psi ={} ;
hog = vl_hog(im, cellSize, 'verbose') ;
psi{i}=hog(:);
psi = cat(1, psi{:}) ;

% --------------------------------------------------------------------
function psi = getFromCache(name, cache)
% --------------------------------------------------------------------
[drop, name] = fileparts(name) ;
cachePath = fullfile(cache, [name '.mat']) ;
if exist(cachePath, 'file')
  data = load(cachePath) ;
  psi = data.psi ;
else
  psi = [] ;
end

% --------------------------------------------------------------------
function storeToCache(name, cache, psi)
% --------------------------------------------------------------------
[drop, name] = fileparts(name) ;
cachePath = fullfile(cache, [name '.mat']) ;
vl_xmkdir(cache) ;
data.psi = psi ;
save(cachePath, '-STRUCT', 'data') ;


