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

unit HSharp.PEG.Rule.Interfaces;

interface

uses
  HSharp.PEG.Context.Interfaces,
  HSharp.PEG.Expression.Interfaces,
  HSharp.PEG.Node.Interfaces;

type
  IRule = interface
    ['{4288D2E1-362C-468D-AC88-99C2C1E236D7}']
    function GetName: string;
    function GetExpression: IExpression;
    procedure SetExpression(const aExpression: IExpression);
    function Parse(const aContext: IContext): INode;
    function AsString: string;
    property Name: string read GetName;
    property Expression: IExpression read GetExpression write SetExpression;
  end;

implementation

end.