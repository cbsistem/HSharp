{***************************************************************************}
{                                                                           }
{           HSharp Framework for Delphi                                     }
{                                                                           }
{           Copyright (C) 2014 Helton Carlos de Souza                       }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

unit HSharp.PEG.Grammar.Base;

interface

uses
  System.Rtti,
  HSharp.Collections,
  HSharp.Collections.Interfaces,
  HSharp.PEG.Context,
  HSharp.PEG.Context.Interfaces,
  HSharp.PEG.Exceptions,
  HSharp.PEG.Grammar.Interfaces,
  HSharp.PEG.Node.Interfaces,
  HSharp.PEG.Node.Visitors,
  HSharp.PEG.Rule.Interfaces;

type
  TBaseGrammar = class abstract(TInterfacedObject, IBaseGrammar)
  strict private
    FRuleMethodsDict: IDictionary<string, TRttiMethod>;
    FRootRule: IRule; //should be a weak reference?
    FRules: IList<IRule>;
  public
    constructor Create(const aRules: IList<IRule>;
      const aRootRule: IRule = nil); overload; virtual;
    function Parse(const aText: string): INode; virtual;
    function ParseAndVisit(const aText: string): TValue; virtual;
    function AsString: string;
    function Visit(const aNode: INode): TValue; virtual;
    property RuleMethodsDict: IDictionary<string, TRttiMethod> read FRuleMethodsDict;
  end;

implementation

uses
  System.SysUtils,
  HSharp.Core.Arrays,
  HSharp.Core.ArrayString,
  HSharp.Core.Rtti,
  HSharp.PEG.Utils;

{ TGrammar }

function TBaseGrammar.AsString: string;
var
  Rule: IRule;
  Grammar: IArrayString;
begin
  Grammar := TArrayString.Create;
  Grammar.Add(FRootRule.AsString);
  for Rule in FRules do
  begin
    if Rule <> FRootRule then
      Grammar.Add(Rule.AsString);
  end;
  Result := Grammar.AsString;
end;

constructor TBaseGrammar.Create(const aRules: IList<IRule>;
  const aRootRule: IRule);

  procedure MapRules;
  var
    Rule: IRule;
    Method: TRttiMethod;
  begin
    FRuleMethodsDict := Collections.CreateDictionary<string, TRttiMethod>;
    for Rule in FRules do
    begin
      Method := RttiContext.GetType(ClassType).GetMethod('Visit_' + Rule.Name);
      if Assigned(Method) then
        FRuleMethodsDict.Add(Rule.Name, Method);
    end;
  end;

begin
  inherited Create;
  FRules := aRules;
  if Assigned(aRootRule) then
    FRootRule := aRootRule
  else
    FRootRule := FRules.First;
  MapRules;
end;

function TBaseGrammar.Parse(const aText: string): INode;
var
  Context: IContext;
begin
  Context := TContext.Create(aText);
  Result := FRootRule.Parse(Context);
  if not Context.Text.IsEmpty then
    raise EIncompleteParseError.CreateFmt('Rule "%s" matched in its entirely, ' +
      'but it didn''t consume all the text. The non-matching portion of the ' +
      'text is "%s". The generated tree is ' + sLineBreak + '%s',
      [FRootRule.Name, Context.Text, NodeToStr(Result)]);
end;

function TBaseGrammar.ParseAndVisit(const aText: string): TValue;
var
  Node: INode;
begin
  Result := nil;
  Node := Parse(aText);
  Result := Visit(Node);
end;

function TBaseGrammar.Visit(const aNode: INode): TValue;
var
  NodeVisitor: INodeVisitor;
  VisitableNode: IVisitableNode;
begin
  NodeVisitor := TGrammarNodeVisitor.Create(Self, RuleMethodsDict); {TODO -oHelton -cOtimize : Otimize using Visitor as Lazy<INodeVisitor, TGrammarNodeVisitor>}
  if Supports(aNode, IVisitableNode, VisitableNode) then
    Result := VisitableNode.Accept(NodeVisitor);
end;

end.