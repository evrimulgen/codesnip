{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2005-2012, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev$
 * $Date$
 *
 * Interfaces and classes that define and perform searches across snippets in
 * the CodeSnip database. Also declares interfaces and classes to record search
 * criteria.
}


unit USearch;

// TODO: Rewrite this unit - it's all become rather messy!!

interface


uses
  // Delphi
  Classes, Windows {for inlining}, Graphics,
  // Project
  Compilers.UGlobals, DB.USnippet, UBaseObjects, USnippetIDs;


type

  {
  TSearchLogic:
    Types of search. Controls how searches deal with multiple terms either by
    requiring *all* terms to be found or *any* terms to be found. Can be used
    with text search criteria (where the logic applies to the searched for
    words) and compiler search criteria (where the logic applies to compiler
    versions).
  }
  TSearchLogic = (
    slAnd,          // find snippets containing *all* supplied information
    slOr            // find snippets containing *any* supplied information
  );

  {
  ISearchCriteria:
    Base interface for all search criteria. Enables all types of
    search criteria to be passed to any search object.
  }
  ISearchCriteria = interface(IInterface)
    ['{C0F8DD70-ED30-4293-98B7-F1DD07AFAD54}']
    function Match(const Snippet: TSnippet): Boolean;
      {Checks whether a snippet matches the search criteria.
        @param Snippet [in] Snippet to be tested.
        @return True if snippet matches criteria, false if not.
      }
    function IsNull: Boolean;
  end;

  {
  TTextSearchOption:
    Search options used in text search criteria.
  }
  TTextSearchOption = (
    soMatchCase,    // only find words where case matches
    soWholeWord     // only match whole words
  );

  {
  TTextSearchOptions:
    Set of text search options.
  }
  TTextSearchOptions = set of TTextSearchOption;

  {
  ITextSearchCriteria:
    Search criteria for text searches. Stores details of the words to be
    searched for, the search logic and the search options.
  }
  ITextSearchCriteria = interface(ISearchCriteria)
    ['{9A4EB089-F863-48F9-B874-75CA2D75DF05}']
    function GetWords: TStrings;
      {Read accessor for Words property.
        @return List of words to be searched for.
      }
    function GetLogic: TSearchLogic;
      {Read accessor for Logic property.
        @return Search logic to be used: AND or OR.
      }
    function GetOptions: TTextSearchOptions;
      {Read accessor for Options property.
        @return Set of options used to modify how search is performed.
      }
    property Words: TStrings read GetWords;
      {List words to be searched for}
    property Logic: TSearchLogic read GetLogic;
      {Search logic to be used: AND or OR}
    property Options: TTextSearchOptions read GetOptions;
      {Set of options used to modify how search is performed}
  end;

  {
  TCompilerSearchCompilers:
    Set of compiler versions used in compiler search criteria.
  }
  TCompilerSearchCompilers = set of TCompilerID;

  {
  TCompilerSearchOption:
    Search options applied to compiler search criteria.
  }
  TCompilerSearchOption = (
    soCompileOK,      // snippet compiles
    soCompileNoWarn,  // snippet compiles without warnings
    soCompileWarn,    // snippet compiles with warnings
    soCompileFail,    // snippet fails to compile
    soUntested        // snippet compilation not tested
  );

  {
  ICompilerSearchCriteria:
    Search criteria for compiler searches. Stores details of the compilers to be
    searched for, the search logic and options concerning compilation success or
    failure.
  }
  ICompilerSearchCriteria = interface(ISearchCriteria)
    ['{6DFAD486-C142-4B0F-873A-51075E285C0C}']
    function GetCompilers: TCompilerSearchCompilers;
      {Read accessor for Compilers property.
        @return Set of compilers to be included in search.
      }
    function GetLogic: TSearchLogic;
      {Read accessor for Logic property.
        @return Search logic to be used: AND or OR.
      }
    function GetOption: TCompilerSearchOption;
      {Read accessor for Option property.
        @return Option determining the compilation outcome to be searched for.
      }
    property Compilers: TCompilerSearchCompilers read GetCompilers;
      {Set of compilers to be included in search}
    property Logic: TSearchLogic read GetLogic;
      {Search logic to be used: AND or OR}
    property Option: TCompilerSearchOption read GetOption;
      {Option determining the compilation outcome to be searched for}
  end;

  {
  ISelectionSearchCriteria:
    Search criteria for manual snippet selection searches. Stores list of
    snippets to be selected.
  }
  ISelectionSearchCriteria = interface(ISearchCriteria)
    ['{6FA6AC34-439B-4744-ACBC-1836EE140EB6}']
    function GetSelectedItems: ISnippetIDList;
      {Read accessor for SelectedItems property.
        @return List of snippets to be selected in search.
      }
    property SelectedItems: ISnippetIDList read GetSelectedItems;
      {List of snippets to be selected in search}
  end;

  {
  IStoredSelectionSearchCriteria:
    Search criteria for stored snippet selection searches. Stores list of
    snippets to be selected.
  }
  IStoredSelectionSearchCriteria = interface(ISearchCriteria)
    ['{6FA6AC34-439B-4744-ACBC-1836EE140EB6}']
    function GetSelectedItems: ISnippetIDList;
      {Read accessor for SelectedItems property.
        @return List of snippets to be selected in search.
      }
    property SelectedItems: ISnippetIDList read GetSelectedItems;
      {List of snippets to be selected in search}
  end;

  {
  TXRefSearchOption:
    Search options used in XRef search criteria.
  }
  TXRefSearchOption = (
    soRequired,         // include required snippets in search results
    soRequiredRecurse,  // recursively find required snippets
    soSeeAlso,          // include X-refs ("see also") in search results
    soSeeAlsoRecurse,   // recursively find X-refs
    soIncludeSnippet    // include original snippet in search results
  );

  {
  TXRefSearchOptions:
    Set of XRef search options.
  }
  TXRefSearchOptions = set of TXRefSearchOption;

  {
  IXRefSearchCriteria:
    Search criteria for snippet cross-reference searches. Stores details of
    snippet whose x-refs are to be searched along with search options.
  }
  IXRefSearchCriteria = interface(ISearchCriteria)
    ['{92277B2B-AB48-4B3B-8C4F-6DCC71716D79}']
    function GetBaseSnippet: TSnippet;
      {Read accessor for BaseSnippet property.
        @return Reference to initiating snippet.
      }
    function GetOptions: TXRefSearchOptions;
      {Read accessor for Options property.
        @return Set of options controlling XRef search.
      }
    property BaseSnippet: TSnippet read GetBaseSnippet;
      {Initiating snippet for search}
    property Options: TXRefSearchOptions read GetOptions;
      {Options controlling XRef search}
  end;

  {
  ISearchUIInfo:
    Defines methods to be supported by search objects to provide information to
    be used to display search information in the UI.
  }
  ISearchUIInfo = interface(IInterface)
    ['{920CAC6F-3944-42BF-A838-EEB7E76D4BBC}']
    function Glyph: TBitmap;
      {Provides a glyph to be used to indicate kind of search.
        @return Reference to a bitmap storing glyph.
      }
  end;

  {
  ISearch:
    Defines methods to be supported by search objects.
  }
  ISearch = interface(IInterface)
    ['{ADD777B6-28B7-4DF9-B537-F2ECE5CB545C}']
    function GetCriteria: ISearchCriteria;
      {Read accessor for Criteria property.
        @return Criteria to be applied to search.
      }
    function Execute(const InList, FoundList: TSnippetList): Boolean;
      {Executes the search, determining which of a list of snippets match the
      search criteria.
        @param InList [in] List of snippets that the search is applied to.
        @param FoundList [in] List of snippets that match the search criteria.
        @return True if some snippets were found or false if search failed.
      }
    property Criteria: ISearchCriteria read GetCriteria;
      {Criteria to be applied to search}
  end;

  {
  TSearchFactory:
    Static class that creates and clones the different types of search objects.
  }
  TSearchFactory = class(TNoConstructObject)
  public
    class function CreateSearch(Criteria: ISearchCriteria): ISearch;
    class function CreateNulSearch: ISearch;
      {Creates a nul search object.
        @return ISearch interface to nul search object instance.
      }
  end;

  {
  TSearchCriteriaFactory:
    Static class that creates different types of search criteria objects.
  }
  TSearchCriteriaFactory = class(TNoConstructObject)
  public
    class function CreateCompilerSearchCriteria(
      const Compilers: TCompilerSearchCompilers; const Logic: TSearchLogic;
      const Option: TCompilerSearchOption): ICompilerSearchCriteria;
      {Creates a compiler search criteria object with specified property values.
        @param Compilers [in] Set of compilers to be included in search.
        @param Logic [in] Search logic to be used: AND or OR.
        @param Option [in] Compilation outcome to be searched for.
        @return ICompilerSearchCriteria interface to created object.
      }
    class function CreateTextSearchCriteria(
      const Words: string; const Logic: TSearchLogic;
      const Options: TTextSearchOptions): ITextSearchCriteria;
      {Creates a text search criteria object with specified property values.
        @param Words [in] List words to be searched for.
        @param Logic [in] Search logic to be used: AND or OR.
        @param Options [in] Set of options used to modify how search is
          performed.
        @return ITextSearchCriteria interface to created object.
      }
    class function CreateSelectionSearchCriteria(
      const SelectedItems: ISnippetIDList): ISelectionSearchCriteria; overload;
      {Creates a selection search criteria object with specified property
      values.
        @param SelectedItems [in] List snippets to be included in search.
        @return ISelectionSearchCriteria interface to created object.
      }
    class function CreateSelectionSearchCriteria(
      const SelectedSnippets: TSnippetList): ISelectionSearchCriteria; overload;
      {Creates a selection search criteria object with specified property
      values.
        @param SelectedItems [in] List snippets to be included in search.
        @return ISelectionSearchCriteria interface to created object.
      }
    class function CreateStoredSelectionSearchCriteria(
      const SelectedSnippets: ISnippetIDList): IStoredSelectionSearchCriteria;
    class function CreateXRefSearchCriteria(const BaseSnippet: TSnippet;
      const Options: TXRefSearchOptions): IXRefSearchCriteria;
      {Creates a cross-reference search criteria object with specified property
      values.
        @param BaseSnippet [in] Snippet whose cross references are to be
          searched.
        @param Options [in] Options controlling XRef search.
        @return IXRefSearchCriteria interface to created object.
      }
 end;


implementation


uses
  // Delphi
  SysUtils, Character,
  // Project
  ActiveText.UMain, IntfCommon, UStrUtils;


type

  {
  TSearch:
    Abstract base class for non-nul search objects. Each search object must
    indicate whether a given snippet matches a search by overriding the Match
    method.
  }
  TSearch = class sealed(TInterfacedObject, ISearch)
  strict private
    var
      fCriteria: ISearchCriteria;
  protected
    { ISearch methods }
    function Execute(const InList, FoundList: TSnippetList): Boolean;
      {Executes the search, determining which of a list of snippets match the
      search criteria.
        @param InList [in] List of snippets that the search is applied to.
        @param FoundList [in] List of snippets that match the search criteria.
        @return True if some snippets were found or false if search failed.
      }
    function GetCriteria: ISearchCriteria;
  public
    constructor Create(const Criteria: ISearchCriteria);
  end;

  {
  TBaseSearchCriteria:
    Abstract base class for all search criteria objects that implements
    ISearchUIInfo.
  }
  TBaseSearchCriteria = class(TInterfacedObject)
  strict private
    fBitmap: TBitmap;
      {Stores bitmap of glyph associated with search type}
  strict protected
    function GlyphResourceName: string; virtual; abstract;
      {Provides name of required glyph bitmap in resources.
        @return Name of bitmap resource.
      }
  public
    destructor Destroy; override;
      {Class destructor. Tears down object.
      }
    function Glyph: TBitmap;
      {Provides a glyph to be used to indicate kind of search.
        @return Reference to a bitmap storing glyph.
      }
  end;

  {
  TCompilerSearchCriteria:
    Search criteria for compiler searches. Stores details of the compilers to be
    searched for, the search logic and the options concerning compilation
    success or failure.
  }
  TCompilerSearchCriteria = class(TBaseSearchCriteria,
    ISearchCriteria,
    ICompilerSearchCriteria,
    ISearchUIInfo
    )
  strict private
    fCompilers: TCompilerSearchCompilers;
      {Compilers to include in search}
    fLogic: TSearchLogic;
      {Search logic}
    fOption: TCompilerSearchOption;
      {Compile result option}
  strict protected
    function GlyphResourceName: string; override;
      {Provides name of required glyph bitmap in resources.
        @return Name of bitmap resource.
      }
  protected
    { ICompilerSearchCriteria methods }
    function Match(const Snippet: TSnippet): Boolean;
    function IsNull: Boolean;
    function GetCompilers: TCompilerSearchCompilers;
      {Read accessor for Compilers property.
        @return Set of compilers to be included in search.
      }
    function GetLogic: TSearchLogic;
      {Read accessor for Logic property.
        @return Search logic to be used: AND or OR.
      }
    function GetOption: TCompilerSearchOption;
      {Read accessor for Option property.
        @return Option determining the compilation outcome to be searched for.
      }
  public
    constructor Create(const Compilers: TCompilerSearchCompilers;
      const Logic: TSearchLogic; const Option: TCompilerSearchOption);
      {Class consructor. Sets up object with specified property values.
        @param Compilers [in] Set of compilers to be included in search.
        @param Logic [in] Search logic to be used: AND or OR.
        @param Option [in] Determines compilation outcome to be searched for.
      }
  end;

  {
  TTextSearchCriteria:
    Search criteria for text searches. Stores details of the words to be
    searched for, the search logic and the options concerning how the text
    search is implemented.
  }
  TTextSearchCriteria = class(TBaseSearchCriteria,
    ISearchCriteria,
    ITextSearchCriteria,
    ISearchUIInfo
    )
  strict private
    fWords: TStrings;
      {List of search words}
    fLogic: TSearchLogic;
      {Search logic}
    fOptions: TTextSearchOptions;
      {Text search options}
  strict protected
    function GlyphResourceName: string; override;
      {Provides name of required glyph bitmap in resources.
        @return Name of bitmap resource.
      }
  protected
    { ITextSearchCriteria methods }
    function Match(const Snippet: TSnippet): Boolean;
    function IsNull: Boolean;
    function GetWords: TStrings;
      {Read accessor for Words property.
        @return List of words to be searched for.
      }
    function GetLogic: TSearchLogic;
      {Read accessor for Logic property.
        @return Search logic to be used: AND or OR.
      }
    function GetOptions: TTextSearchOptions;
      {Read accessor for Options property.
        @return Set of options used to modify how search is performed.
      }
  public
    constructor Create(const Words: string; const Logic: TSearchLogic;
      const Options: TTextSearchOptions);
      {Class constructor. Sets up object with specified property values.
        @param Words [in] Words to be searched for, separated by spaces.
        @param Logic [in] Search logic to be used: AND or OR.
        @param Options [in] Set of options used to modify how search is
          performed.
      }
    destructor Destroy; override;
      {Class destructor. Tears down object.
      }
  end;

  {
  TSelectionSearchCriteria:
    Search criteria for selection searches. Stores names of items to be
    selected.
  }
  TSelectionSearchCriteria = class(TBaseSearchCriteria,
    ISearchCriteria,
    ISelectionSearchCriteria,
    ISearchUIInfo
  )
  strict private
    var
      fSelectedItems: ISnippetIDList;
        {List snippets ids to be selected in search}
  strict protected
    function GlyphResourceName: string; override;
      {Provides name of required glyph bitmap in resources.
        @return Name of bitmap resource.
      }
  protected
    { ISelectionSearchCriteria methods }
    function Match(const Snippet: TSnippet): Boolean;
    function IsNull: Boolean;
    function GetSelectedItems: ISnippetIDList;
      {Read accessor for SelectedItems property.
        @return List of snippets to be selected in search.
      }
  public
    constructor Create(const SelectedItems: ISnippetIDList);
      {Class constructor. Sets up object with specified property values.
        @param SelectedItems [in] List of snippets to be selected in search.
      }
  end;

  TStoredSelectionSearchCriteria = class(TBaseSearchCriteria,
    ISearchCriteria,
    IStoredSelectionSearchCriteria,
    ISearchUIInfo
  )
  strict private
    var
      fSelectedItems: ISnippetIDList;
        {List snippets ids to be selected in search}
  strict protected
    function GlyphResourceName: string; override;
      {Provides name of required glyph bitmap in resources.
        @return Name of bitmap resource.
      }
  protected
    { ISelectionSearchCriteria methods }
    function Match(const Snippet: TSnippet): Boolean;
    function IsNull: Boolean;
    function GetSelectedItems: ISnippetIDList;
      {Read accessor for SelectedItems property.
        @return List of snippets to be selected in search.
      }
  public
    constructor Create(const SelectedItems: ISnippetIDList);
      {Class constructor. Sets up object with specified property values.
        @param SelectedItems [in] List of snippets to be selected in search.
      }
  end;

  {
  TXRefSearchCriteria:
    Search criteria for cross-reference searches. Stores snippet whose x-refs
    are to be searched along with search options.
  }
  TXRefSearchCriteria = class(TBaseSearchCriteria,
    ISearchCriteria,
    IXRefSearchCriteria,
    ISearchUIInfo
  )
  strict private
    fBaseSnippet: TSnippet;
      {Snippet to which search of cross-references applies}
    fOptions: TXRefSearchOptions;
      {Set of poptions controlling XRef search}
    fXRefs: TSnippetList;
    function AddToXRefs(const Snippet: TSnippet): Boolean;
    procedure ReferenceRequired(const Snippet: TSnippet);
    procedure ReferenceSnippet(const Snippet: TSnippet);
    procedure ReferenceSeeAlso(const Snippet: TSnippet);
    procedure Initialise;
  strict protected
    function GlyphResourceName: string; override;
      {Provides name of required glyph bitmap in resources.
        @return Name of bitmap resource.
      }
  protected
    { IXRefSearchCriteria methods }
    function Match(const Snippet: TSnippet): Boolean;
    function IsNull: Boolean;
    function GetBaseSnippet: TSnippet;
      {Read accessor for BaseSnippet property.
        @return Reference to initiating snippet.
      }
    function GetOptions: TXRefSearchOptions;
      {Read accessor for Options property.
        @return Set of options controlling XRef search.
      }
  public
    constructor Create(const BaseSnippet: TSnippet;
      const Options: TXRefSearchOptions);
      {Class constructor. Sets up object with specified property values.
        @param BaseSnippet [in] Snippet whose cross references are to be
          searched.
        @param Options [in] Set of options conrtolling search.
      }
    destructor Destroy; override;
  end;

  {
  TNulSearchCriteria:
    Do nothing object that implements the nul search criteria interface UI info
    interfaces.
  }
  TNulSearchCriteria = class(TBaseSearchCriteria,
    ISearchCriteria,
    ISearchUIInfo
    )
  strict protected
    function Match(const Snippet: TSnippet): Boolean;
    function IsNull: Boolean;
    function GlyphResourceName: string; override;
      {Provides name of required glyph bitmap in resources.
        @return Name of bitmap resource.
      }
  end;

{ TSearch }

constructor TSearch.Create(const Criteria: ISearchCriteria);
begin
  Assert(Assigned(Criteria), ClassName + '.Create: Criteria is nil');
  inherited Create;
  fCriteria := Criteria;
end;

function TSearch.Execute(const InList, FoundList: TSnippetList): Boolean;
  {Executes the search, determining which of a list of snippets match the search
  criteria.
    @param InList [in] List of snippets that the search is applied to.
    @param FoundList [in] List of snippets that match the search criteria.
    @return True if some snippets were found or false if search failed.
  }
var
  Snippet: TSnippet;    // each snippet in InList
begin
  Assert(Assigned(InList), ClassName + '.Execute: InList is nil');
  Assert(Assigned(FoundList), ClassName + '.Execute: FoundList is nil');
  Assert(InList <> FoundList, ClassName + '.Execute: InList = FoundList');

  FoundList.Clear;
  for Snippet in InList do
    if GetCriteria.Match(Snippet) then
      FoundList.Add(Snippet);
  Result := FoundList.Count > 0;
end;

function TSearch.GetCriteria: ISearchCriteria;
begin
  Result := fCriteria;
end;

{ TBaseSearchCriteria }

destructor TBaseSearchCriteria.Destroy;
  {Class destructor. Tears down object.
  }
begin
  FreeAndNil(fBitmap);
  inherited;
end;

function TBaseSearchCriteria.Glyph: TBitmap;
  {Provides a glyph to be used to indicate kind of search.
    @return Reference to a bitmap storing glyph.
  }
begin
  if not Assigned(fBitmap) then
  begin
    // Bitmap not yet created: create it and load from resources
    fBitmap := TBitmap.Create;
    fBitmap.LoadFromResourceName(HInstance, GlyphResourceName);
  end;
  Result := fBitmap;
end;

{ TCompilerSearchCriteria }

constructor TCompilerSearchCriteria.Create(
  const Compilers: TCompilerSearchCompilers; const Logic: TSearchLogic;
  const Option: TCompilerSearchOption);
  {Class consructor. Sets up object with specified property values.
    @param Compilers [in] Set of compilers to be included in search.
    @param Logic [in] Search logic to be used: AND or OR.
    @param Option [in] Determines compilation outcome to be searched for.
  }
begin
  inherited Create;
  // Store properties
  fCompilers := Compilers;
  fLogic := Logic;
  fOption := Option;
end;

function TCompilerSearchCriteria.GetCompilers: TCompilerSearchCompilers;
  {Read accessor for Compilers property.
    @return Set of compilers to be included in search.
  }
begin
  Result := fCompilers;
end;

function TCompilerSearchCriteria.GetLogic: TSearchLogic;
  {Read accessor for Logic property.
    @return Search logic to be used: AND or OR.
  }
begin
  Result := fLogic;
end;

function TCompilerSearchCriteria.GetOption: TCompilerSearchOption;
  {Read accessor for Option property.
    @return Option determining the compilation outcome to be searched for.
  }
begin
  Result := fOption;
end;

function TCompilerSearchCriteria.GlyphResourceName: string;
  {Provides name of required glyph bitmap in resources.
    @return Name of bitmap resource.
  }
begin
  Result := 'COMPILERSEARCH';
end;

function TCompilerSearchCriteria.IsNull: Boolean;
begin
  Result := False;
end;

function TCompilerSearchCriteria.Match(const Snippet: TSnippet): Boolean;
const
  // Maps compiler search option onto set of compiler results it describes
  cCompatMap: array[TCompilerSearchOption] of set of TCompileResult = (
    [crSuccess, crWarning],   // soCompileOK,
    [crSuccess],              // soCompileNoWarn,
    [crWarning],              // soCompileWarn,
    [crError],                // soCompileFail,
    [crQuery]                 // soUnkown
  );

  // Checks if a snippet's compiler result for given compiler ID matches
  // expected results.
  function CompatibilityMatches(const CompID: TCompilerID): Boolean;
  begin
    Result := Snippet.Compatibility[CompID] in cCompatMap[fOption];
  end;

var
  CompID: TCompilerID;  // loops thru supported compilers
begin
  if fLogic = slOr then
  begin
    // Find any compiler: we return true as soon as any compiler compatibility
    // matches
    Result := False;
    for CompID in fCompilers do
    begin
      if CompatibilityMatches(CompID) then
        Exit(True);
    end;
  end
  else {fLogic = slAnd}
  begin
    // Find all compilers: we return false as soon as any compiler compatibility
    // doesn't match
    Result := True;
    for CompID in fCompilers do
    begin
      if not CompatibilityMatches(CompID) then
        Exit(False);
    end;
  end;
end;

{ TTextSearchCriteria }

constructor TTextSearchCriteria.Create(const Words: string;
  const Logic: TSearchLogic; const Options: TTextSearchOptions);
  {Class constructor. Sets up object with specified property values.
    @param Words [in] Words to be searched for, separated by spaces.
    @param Logic [in] Search logic to be used: AND or OR.
    @param Options [in] Set of options used to modify how search is performed.
  }
begin
  Assert(Words <> '', ClassName + '.Create: Words is empty string');
  inherited Create;
  // Store properties
  fLogic := Logic;
  fOptions := Options;
  // store each search word as entry in string list
  fWords := TStringList.Create;
  StrExplode(StrCompressWhiteSpace(Words), ' ', fWords);
end;

destructor TTextSearchCriteria.Destroy;
  {Class destructor. Tears down object.
  }
begin
  fWords.Free;
  inherited;
end;

function TTextSearchCriteria.GetLogic: TSearchLogic;
  {Read accessor for Logic property.
    @return Search logic to be used: AND or OR.
  }
begin
  Result := fLogic;
end;

function TTextSearchCriteria.GetOptions: TTextSearchOptions;
  {Read accessor for Options property.
    @return Set of options used to modify how search is performed.
  }
begin
  Result := fOptions;
end;

function TTextSearchCriteria.GetWords: TStrings;
  {Read accessor for Words property.
    @return List of words to be searched for.
  }
begin
  Result := fWords;
end;

function TTextSearchCriteria.GlyphResourceName: string;
  {Provides name of required glyph bitmap in resources.
    @return Name of bitmap resource.
  }
begin
  Result := 'TEXTSEARCH';
end;

function TTextSearchCriteria.IsNull: Boolean;
begin
  Result := False;
end;

function TTextSearchCriteria.Match(const Snippet: TSnippet): Boolean;
  // ---------------------------------------------------------------------------
  function NormaliseSearchText(const RawText: string): string;
    {Converts the text to be searched into a standard format.
      @param RawText [in] Text to be normalised.
      @return Normalised text: quote characters are deleted, all words ending in
        punctuation are included in list in punctuated and non-punctuated state
        and all words are separated by a single space.
    }

    // Replace each white space char in string S with single space character.
    function WhiteSpaceToSpaces(const S: string): string;
    var
      Idx: Integer; // loops through chars of S
    begin
      // Pre-size spaced text string: same size as raw text input
      SetLength(Result, Length(S));
      // Convert all white space characters to spaces
      for Idx := 1 to Length(S) do
      begin
        if TCharacter.IsWhiteSpace(S[Idx]) then
          Result[Idx] := ' '
        else
          Result[Idx] := S[Idx]
      end;
    end;

    // Strip single and double quotes from a string S.
    procedure StripQuotes(var S: string);
    begin
      if S = '' then
        Exit;
      if (S[1] = '''') or (S[1] = '"') then
        Delete(S, 1, 1);
      if (S <> '') and
        ((S[Length(S)] = '''') or (S[Length(S)] = '"')) then
        Delete(S, Length(S), 1);
    end;

  var
    Words: TStringList;         // list of words from raw text
    Word: string;               // a word from Words list
    WordIdx: Integer;           // index into Words list
    ExtraWords: TStringList;    // extra search words derived from Words list
  const
    // Characters that can end words
    cWordEnders = [
      '!', '"', '%', '^', '&', '*', '(', ')', '-', '+', '=',
      '{', '}', '[', ']', ':', ';', '~', '<', '>', ',', '.',
      '?', '/', '|', '\', ''''
    ];
  begin
    ExtraWords := nil;
    Words := TStringList.Create;
    try
      ExtraWords := TStringList.Create;
      // Convert text to word list and process each word
      StrExplode(WhiteSpaceToSpaces(RawText), ' ', Words, False);
      for WordIdx := 0 to Pred(Words.Count) do
      begin
        Word := Words[WordIdx];
        StripQuotes(Word);
        Words[WordIdx] := Word;
        // Add any word ending in punctuation in non-punctuated state
        // (note that any word ending in x punctuation character will be added
        // several times, once with each of x, x-1, x-2 ... 0 punctuation
        // characters.
        // We need to do this in case user searches for a word followed by one
        // or more punctuation characters.
        while (Word <> '') and CharInSet(Word[Length(Word)], cWordEnders) do
        begin
          // we add any variations to Extra words list
          Delete(Word, Length(Word), 1);
          ExtraWords.Add(Word);
        end;
      end;
      Result := ' ' + StrJoin(Words, ' ', False) + ' '
        + StrJoin(ExtraWords, ' ', False) + ' ';
      if not (soMatchCase in fOptions) then
        Result := StrToLower(Result);
    finally
      ExtraWords.Free;
      Words.Free;
    end;
  end;

  function NormaliseSearchWord(const Word: string): string;
    {Converts a word being searched for into correct format for searching
    depending on search options.
      @param Word [in] Word to be normalised.
      @return Normalised word: if case being ignored word is lower case and if
        whole words being matched word is topped and tailed by a space.
    }
  begin
    Result := Word;
    if not (soMatchCase in fOptions) then
      Result := StrToLower(Result);
    if soWholeWord in fOptions then
      Result := ' ' + Result + ' ';
  end;
  // ---------------------------------------------------------------------------

var
  SearchText: string; // text we're searching in
  SearchWord: string; // a word we're searching for
begin
  // Build search text
  SearchText := NormaliseSearchText(
    ' ' + StrMakeSentence(Snippet.Description.ToString) +
    ' ' + Snippet.SourceCode +
    ' ' + StrMakeSentence(Snippet.Extra.ToString) +
    ' '
  );
  if fLogic = slOr then
  begin
    // Find any of words in search text: return True as soon as any word matches
    Result := False;
    for SearchWord in fWords do
      if StrContainsStr(NormaliseSearchWord(SearchWord), SearchText) then
        Exit(True);
  end
  else {fLogic = slAnd}
  begin
    // Find all words in search text: return False as soon as any word doesn't
    // match
    Result := True;
    for SearchWord in fWords do
      if not StrContainsStr(NormaliseSearchWord(SearchWord), SearchText) then
        Exit(False);
  end;
end;

{ TSelectionSearchCriteria }

constructor TSelectionSearchCriteria.Create(
  const SelectedItems: ISnippetIDList);
  {Class constructor. Sets up object with specified property values.
    @param SelectedItems [in] List of snippets to be selected in search.
  }
begin
  inherited Create;
  fSelectedItems := TSnippetIDList.Create;
  (fSelectedItems as IAssignable).Assign(SelectedItems);
end;

function TSelectionSearchCriteria.GetSelectedItems: ISnippetIDList;
  {Read accessor for SelectedItems property.
    @return List of snippets to be selected in search.
  }
begin
  Result := fSelectedItems;
end;

function TSelectionSearchCriteria.GlyphResourceName: string;
  {Provides name of required glyph bitmap in resources.
    @return Name of bitmap resource.
  }
begin
  Result := 'SELECTIONSEARCH';
end;

function TSelectionSearchCriteria.IsNull: Boolean;
begin
  Result := False;
end;

function TSelectionSearchCriteria.Match(const Snippet: TSnippet): Boolean;
begin
  Result := fSelectedItems.Contains(Snippet.ID);
end;

{ TStoredSelectionSearchCriteria }

constructor TStoredSelectionSearchCriteria.Create(
  const SelectedItems: ISnippetIDList);
begin
  inherited Create;
  fSelectedItems := TSnippetIDList.Create;
  (fSelectedItems as IAssignable).Assign(SelectedItems);
end;

function TStoredSelectionSearchCriteria.GetSelectedItems: ISnippetIDList;
begin
  Result := fSelectedItems;
end;

function TStoredSelectionSearchCriteria.GlyphResourceName: string;
begin
  Result := 'STOREDSELECTIONSEARCH';
end;

function TStoredSelectionSearchCriteria.IsNull: Boolean;
begin
  Result := False;
end;

function TStoredSelectionSearchCriteria.Match(const Snippet: TSnippet): Boolean;
begin
  Result := fSelectedItems.Contains(Snippet.ID);
end;

{ TXRefSearchCriteria }

function TXRefSearchCriteria.AddToXRefs(const Snippet: TSnippet): Boolean;
begin
  Result := not fXRefs.Contains(Snippet);
  if Result then
    fXRefs.Add(Snippet);
end;

constructor TXRefSearchCriteria.Create(const BaseSnippet: TSnippet;
  const Options: TXRefSearchOptions);
  {Class constructor. Sets up object with specified property values.
    @param BaseSnippet [in] Snippet whose cross references are to be searched.
    @param Options [in] Set of options conrtolling search.
  }
begin
  Assert(Assigned(BaseSnippet), ClassName + '.Create: BaseSnippet is nil');
  inherited Create;
  fBaseSnippet := BaseSnippet;
  fOptions := Options;
end;

destructor TXRefSearchCriteria.Destroy;
begin
  fXRefs.Free;
  inherited;
end;

function TXRefSearchCriteria.GetBaseSnippet: TSnippet;
  {Read accessor for BaseSnippet property.
    @return Reference to initiating snippet.
  }
begin
  Result := fBaseSnippet;
end;

function TXRefSearchCriteria.GetOptions: TXRefSearchOptions;
  {Read accessor for Options property.
    @return Set of options controlling XRef search.
  }
begin
  Result := fOptions;
end;

function TXRefSearchCriteria.GlyphResourceName: string;
  {Provides name of required glyph bitmap in resources.
    @return Name of bitmap resource.
  }
begin
  Result := 'XREFSEARCH';
end;

procedure TXRefSearchCriteria.Initialise;
begin
  Assert(Assigned(fXRefs), ClassName + '.Initialise: fXRefs is nil');
  Assert(fXRefs.Count = 0, ClassName + '.Initialise: fXRefs not empty');
  ReferenceRequired(fBaseSnippet);
  ReferenceSeeAlso(fBaseSnippet);
  if soIncludeSnippet in fOptions then
    AddToXRefs(fBaseSnippet);
end;

function TXRefSearchCriteria.IsNull: Boolean;
begin
  Result := False;
end;

function TXRefSearchCriteria.Match(const Snippet: TSnippet): Boolean;
begin
  // Check if cross references are still to be calcaluted and do it if so
  // We do this here to avoid the overhead if just using object to store / read
  // persistent settings.
  if not Assigned(fXRefs) then
  begin
    fXRefs := TSnippetList.Create;
    Initialise;
  end;
  Result := fXRefs.Contains(Snippet);
end;

procedure TXRefSearchCriteria.ReferenceRequired(const Snippet: TSnippet);
var
  Idx: Integer; // loops thru all required snippets
begin
  if soRequired in fOptions then
    for Idx := 0 to Pred(Snippet.Depends.Count) do
      ReferenceSnippet(Snippet.Depends[Idx]);
end;

procedure TXRefSearchCriteria.ReferenceSeeAlso(const Snippet: TSnippet);
var
  Idx: Integer; // loops thru all "see also" snippets
begin
  if soSeeAlso in fOptions then
    for Idx := 0 to Pred(Snippet.XRef.Count) do
      ReferenceSnippet(Snippet.XRef[Idx]);
end;

procedure TXRefSearchCriteria.ReferenceSnippet(const Snippet: TSnippet);
begin
  // Add snippet to list if not present. Quit if snippet already referenced.
  if not AddToXRefs(Snippet) then
    Exit;
  // Recurse required snippets if specified in options
  if soRequiredRecurse in fOptions then
    ReferenceRequired(Snippet);
  // Recurse "see also" snippets if specified in options
  if soSeeAlsoRecurse in fOptions then
    ReferenceSeeAlso(Snippet);
end;

{ TNulSearchCriteria }

function TNulSearchCriteria.GlyphResourceName: string;
  {Provides name of required glyph bitmap in resources.
    @return Name of bitmap resource.
  }
begin
  Result := 'NULSEARCH';
end;

function TNulSearchCriteria.IsNull: Boolean;
begin
  Result := True;
end;

function TNulSearchCriteria.Match(const Snippet: TSnippet): Boolean;
begin
  Result := True;
end;

{ TSearchFactory }

class function TSearchFactory.CreateNulSearch: ISearch;
  {Creates a nul search object.
    @return ISearch interface to nul search object instance.
  }
begin
  Result := CreateSearch(TNulSearchCriteria.Create);
end;

class function TSearchFactory.CreateSearch(Criteria: ISearchCriteria): ISearch;
begin
  Result := TSearch.Create(Criteria);
end;

{ TSearchCriteriaFactory }

class function TSearchCriteriaFactory.CreateCompilerSearchCriteria(
  const Compilers: TCompilerSearchCompilers; const Logic: TSearchLogic;
  const Option: TCompilerSearchOption): ICompilerSearchCriteria;
  {Creates a compiler search criteria object with specified property values.
    @param Compilers [in] Set of compilers to be included in search.
    @param Logic [in] Search logic to be used: AND or OR.
    @param Option [in] Compilation outcome to be searched for.
    @return ICompilerSearchCriteria interface to created object.
  }
begin
  Result := TCompilerSearchCriteria.Create(Compilers, Logic, Option);
end;

class function TSearchCriteriaFactory.CreateSelectionSearchCriteria(
  const SelectedSnippets: TSnippetList): ISelectionSearchCriteria;
  {Creates a selection search criteria object with specified property values.
    @param SelectedItems [in] List of snippets to be included in search.
    @return ISelectionSearchCriteria interface to created object.
  }
var
  SnippetIDs: ISnippetIDList; // snippet id list
  Snippet: TSnippet;          // each snippet in SelectedSnippets
begin
  SnippetIDs := TSnippetIDList.Create;
  for Snippet in SelectedSnippets do
    SnippetIDs.Add(Snippet.ID);
  Result := TSelectionSearchCriteria.Create(SnippetIDs);
end;

class function TSearchCriteriaFactory.CreateSelectionSearchCriteria(
  const SelectedItems: ISnippetIDList): ISelectionSearchCriteria;
begin
  Result := TSelectionSearchCriteria.Create(SelectedItems);
end;

class function TSearchCriteriaFactory.CreateStoredSelectionSearchCriteria(
  const SelectedSnippets: ISnippetIDList): IStoredSelectionSearchCriteria;
begin
  Result := TStoredSelectionSearchCriteria.Create(SelectedSnippets);
end;

class function TSearchCriteriaFactory.CreateTextSearchCriteria(
  const Words: string; const Logic: TSearchLogic;
  const Options: TTextSearchOptions): ITextSearchCriteria;
  {Creates a text search criteria object with specified property values.
    @param Words [in] List words to be searched for.
    @param Logic [in] Search logic to be used: AND or OR.
    @param Options [in] Set of options used to modify how search is performed.
    @return ITextSearchCriteria interface to created object.
  }
begin
  Result := TTextSearchCriteria.Create(Words, Logic, Options);
end;

class function TSearchCriteriaFactory.CreateXRefSearchCriteria(
  const BaseSnippet: TSnippet;
  const Options: TXRefSearchOptions): IXRefSearchCriteria;
  {Creates a cross-reference search criteria object with specified property
  values.
    @param BaseSnippet [in] Snippet whose cross references are to be searched.
    @param Options [in] Options controlling XRef search.
    @return IXRefSearchCriteria interface to created object.
  }
begin
  Result := TXRefSearchCriteria.Create(BaseSnippet, Options);
end;

end.

