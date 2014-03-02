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

unit HSharp.PEG.Node;

interface

uses
  System.RegularExpressions,
  System.Rtti,
  HSharp.Collections,
  HSharp.Collections.Interfaces,
  HSharp.PEG.Node.Interfaces;

type
  TNode = class(TInterfacedObject, INode, IVisitableNode)
  strict private
    FName: string;
    FText: string;
    FIndex: Integer;
    FChildren: IList<INode>;
  strict protected
    { INode }
    function GetChildren: IList<INode>;
    function GetIndex: Integer;
    function GetName: string;
    function GetText: string;
    { IVisitableNode }
    function Accept(const aVisitor: INodeVisitor): TValue;
  public
    constructor Create(const aName, aText: string; aIndex: Integer;
      const aChildren: IList<INode> = nil); reintroduce;
  end;

  TRegexNode = class(TNode, IRegexNode)
  strict private
    FMatch: TMatch;
  strict protected
    function GetMatch: TMatch;
  public
    constructor Create(const aName: string; aMatch: TMatch; aIndex: Integer;
       const aChildren: IList<INode> = nil); reintroduce;
  end;

implementation

uses
  System.SysUtils,
  HSharp.Core.ArrayString;

{ TNode }

function TNode.Accept(const aVisitor: INodeVisitor): TValue;
begin
  Result := aVisitor.Visit(Self);
end;

constructor TNode.Create(const aName, aText: string; aIndex: Integer;
  const aChildren: IList<INode>);
begin
  inherited Create;
  FName := aName;
  FText := aText;
  FIndex := aIndex;
  FChildren := aChildren;
end;

function TNode.GetChildren: IList<INode>;
begin
  Result := FChildren;
end;

function TNode.GetIndex: Integer;
begin
  Result := FIndex;
end;

function TNode.GetName: string;
begin
  Result := FName;
end;

function TNode.GetText: string;
begin
  Result := FText;
end;

{ TRegexNode }

constructor TRegexNode.Create(const aName: string; aMatch: TMatch;
  aIndex: Integer; const aChildren: IList<INode>);
begin
  inherited Create(aName, aMatch.Value, aIndex, aChildren);
  FMatch := aMatch;
end;

function TRegexNode.GetMatch: TMatch;
begin
  Result := FMatch;
end;

end.
